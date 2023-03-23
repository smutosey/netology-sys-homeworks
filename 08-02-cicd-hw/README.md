# Домашнее задание к занятию "`8.2. Что такое DevOps. СI/СD`" - `Александр Недорезов`

---

### Задание 1

1. Установите себе jenkins, следуя инструкции из лекции (или любым другим способом из официальной документации). Использовать docker в данном задании нежелательно.
2. Установите на машину с jenkins [golang](https://golang.org/doc/install).
3. Используя свой аккаунт на GitHub, сделайте себе форк [репозитория](https://github.com/netology-code/sdvps-materials.git). В этом же репозитории находится [дополнительный материал для выполнения ДЗ](https://github.com/netology-code/sdvps-materials/CICD/8.2-hw.md).
3. Создайте в дженкинсе freestyle проект, подключите получившийся репозиторий к нему и произведите запуск тестов и сборку проекта ```go test .``` и  ```docker build .```
*В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки*

### Ответ

#### *Настройки проекта:*
Описание:
![Описание](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/screen-1.png)
SCM:
![SCM](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/screen-2.png)
Триггеры сборки:
![Триггеры сборки](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/screen-3.png)
Шаги сборки:
![Шаги сборки](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/screen-4.png)

#### *Результат сборки:*
Статус пайплайна:
![Статус пайплайна](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/screen-6.png)
Конец лога:
![Конец лога](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/screen-7.png)
Собранный image в Docker:
![image](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/screen-5.png)

---

### Задание 2

1. Создайте новый проект pipeline.
2. Перепишите сборку из задания 1 на declarative(в виде кода).
*В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки*

### Ответ
Declarative pipeline:
```Groovy
pipeline {
    agent any
    stages {
        stage('Git clone') {
            steps {
                git 'https://github.com/netology-code/sdvps-materials.git'
            }
        }
        stage('Run tests') {
            steps {
                sh '/usr/local/go/bin/go test .'
            }
        }
        stage('Build go app in docker image') {
            steps {
                sh 'docker build . -t cicd-host:8082/hello-world:decl_v$BUILD_NUMBER'
            }
        }
    }
}
```
#### *Результат сборки:*
Статус пайплайна:
![Статус пайплайна](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/2-screen-1.png)
Собранный image в Docker:
![image-2](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/2-screen-2.png)

---

### Задание 3

1. Установите на машину Nexus.
1. Создайте raw-hosted репозиторий.
1. Измените пайплайн таким образом, чтобы вместо docker-образа собирался бинарный go-файл (команду можно скопировать из Dockerfile).
1. Загрузите файл в репозиторий с помощью jenkins
*В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки*

### Ответ
Репозиторий:
![image-1](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/3-screen-1.png)
Пайплайн:
```Groovy
pipeline {
    agent any
    stages {
        stage('Git clone') {
            steps {
                git 'https://github.com/netology-code/sdvps-materials.git'
            }
        }
        stage('Run tests') {
            steps {
                sh '/usr/local/go/bin/go test .'
            }
        }
        stage('Build go app and push to Nexus repo') {
            steps {
                sh 'CGO_ENABLED=0 GOOS=linux /usr/local/go/bin/go build -a -installsuffix nocgo -o ./go-app .'
                sh 'curl -u admin:admin http://cicd-host:8081/repository/raw-hosted-repo/ --upload-file ./go-app -v'
            }
        }
    }
}
```
#### *Результат сборки*
Прогон пайплайна:
![image-2](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/3-screen-2.png)
Приложение в репозитории:
![image-3](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/3-screen-3.png)


---

### Задание 4*

Придумайте способ версионировать приложение, чтобы каждый следующий запуск сборки присваивал имени файла новую версию. Таким образом, в репозитории Nexus будет храниться история релизов.
*В качестве ответа пришлите скриншоты с настройками проекта и результатами выполнения сборки*

### Ответ
Достаточно внести изменения в стадию Build, использовать в имени файла переменную (go-app-v$BUILD_NUMBER):
```Groovy
stage('Build go app and push to Nexus repo') {
    steps {
        sh 'CGO_ENABLED=0 GOOS=linux /usr/local/go/bin/go build -a -installsuffix nocgo -o ./go-app-v$BUILD_NUMBER .'
        sh 'curl -u admin:admin http://cicd-host:8081/repository/raw-hosted-repo/ --upload-file ./go-app-v$BUILD_NUMBER -v'
    }
}
```
#### *Результат сборки*
Несколько запусков пайплайна:
![image-1](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/4-screen-1.png)
Версионирование приложения в репозитории:
![image-2](https://github.com/smutosey/sys-netology-hw/blob/main/08-02-cicd-hw/img/4-screen-2.png)
