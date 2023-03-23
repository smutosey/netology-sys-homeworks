# Домашнее задание к занятию "`10.3. Pacemaker`" - `Александр Недорезов`



### Задание 1

Опишите основные функции и назначение Pacemaker.

*Приведите ответ в свободной форме.*

### Ответ

Pacemaker — это менеджер ресурсов кластеров высокой доступности, позволяет использовать службы и объекты в рамках одного кластера из двух или более нод. 
Его главная задача — достижение максимальной доступности ресурсов, которыми он управляет, и защита их от сбоев. Во время работы кластера происходят различные события – сбой, присоединение узлов, ресурсов, переход узлов в сервисный режим и другие. Pacemaker реагирует на эти события в кластере, выполняя действия, на которые он запрограммирован., например, остановку ресурсов, перенос ресурсов и другие.

Имеет следующие фичи:
* Позволяет находить и устранять сбои на уровне нод и служб;
* Не зависит от подсистемы хранения: можем забыть общий накопитель, как страшный сон;
* Независимость от типов ресурсов: все, что можно прописать в скрипты, можно кластеризовать;
* Поддержка STONITH (Shoot-The-Other-Node-In-The-Head) — то есть умершая нода изолируется и запросы к ней не поступают, пока нода не отправит сообщение о том, что она снова в рабочем состоянии;
* Поддерживает кворумные и ресурсозависимые кластеры любого размера, практически любую избыточную конфигурацию;
* Автоматическая репликация конфига на все узлы кластера;
* Возможность задания порядка запуска ресурсов, а также их совместимости на одном узле;
* Поддержка расширенных типов ресурсов: клонов (запущен на множестве узлов) и с дополнительными состояниями (master/slave и т.п.);
* Имеет единую кластерную оболочку CRM с поддержкой скриптов.

---
---

### Задание 2

Опишите основные функции и назначение Corosync.

*Приведите ответ в свободной форме.*

### Ответ

Corosync - программный продукт, который позволяет создавать единый кластер из нескольких аппаратных или виртуальных серверов. Corosync отслеживает и передает состояние всех участников (нод) в кластере.

Позволяет: 
* мониторить статус приложений;
* оповещать приложения о смене активной ноды в кластере;
* отправлять идентичные сообщения процессам на всех нодах;
* предоставлять доступ к общей базе данных с конфигурацией и статистикой;
* отправлять уведомления об изменениях, произведенных в базе.

---
---

### Задание 3

Соберите модель, состоящую из двух виртуальных машин. Установите Pacemaker, Corosync, Pcs. Настройте HA кластер.

*Пришлите скриншот рабочей конфигурации и состояния сервиса для каждого нода.*

### Ответ

Создание ВМ для д/з большая часть настройки хостов описана в Vagrantfile
Получилась конфигурация по сервисам:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/03-3.png)

Статус кластера на node-1:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/03-1.png)

Статус кластера на node-2:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/03-2.png)


---
---

### Задание 4*

Установите и настройте DRBD-сервис для настроенного кластера.

*Пришлите скриншот рабочей конфигурации и состояние сервиса для каждого нода.*


### <ins>Ответ</ins>

На обеих нодах: 
```bash
vgcreate vg /dev/sdb
lvcreate --name drbd --size 1020M vg
```

Конфигурация ресурса: /etc/drbd.d/wwwdata.res
```
resource wwwdata {
 protocol C;
 meta-disk internal;
 device /dev/drbd2;
 syncer {
  verify-alg sha1;
 }
 net {
  allow-two-primaries;
 }
 on nodeone {
  disk   /dev/vg/drbd;
  address  192.168.2.10:7795;
  meta-disk internal;
 }
 on nodetwo {
  disk   /dev/vg/drbd;
  address  192.168.2.20:7795;
  meta-disk internal;
 }
}
```

Создаем ресурс
```bash
drbdadm create-md wwwdata
drbdadm up wwwdata
```

Настраиваем мастер-ноду:
```bash
drbdadm primary --force wwwdata
mkfs.xfs /dev/drbd2
mount /dev/drbd2 /mnt/www
```

Запуск и синхронизация прошли успешно, статус drbd на мастер-ноде: 
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/04-1.png)

статус на слэйв-ноде: 
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/04-2.png)

Проверка сохранения данных на реплике, если Primary-нода (nodeone) упала:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/04-3.png)
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/04-4.png)


формируем конфигурацию Pcs

```bash
pcs property set stonith-enabled=false
pcs property set no-quorum-policy=ignore
pcs resource create virtual_ip ocf:heartbeat:IPaddr2 ip=192.168.0.10 cidr_netmask=24 op monitor interval=60s
pcs cluster cib drbd_cfg
pcs -f drbd_cfg resource create WebData ocf:linbit:drbd drbd_resource=wwwdata op monitor interval=60s
pcs -f drbd_cfg resource promotable WebData promoted-max=1 promoted-node-max=1 clone-max=2 clone-node-max=1 notify=true
pcs -f drbd_cfg resource status
pcs cluster cib-push drbd_cfg --config
```

В результате статус кластера и ресурсов:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/04-9.png)

И статусы, если упала secondary-нода, например:
![img](https://github.com/smutosey/sys-netology-hw/blob/main/10-03-pacemaker/img/04-8.png)

---
