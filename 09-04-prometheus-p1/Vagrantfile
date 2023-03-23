# -*- mode: ruby -*-
# vi: set ft=ruby :

# VM array
HOST_EXPORTER_ONE_IP = "192.168.0.201"
HOST_EXPORTER_TWO_IP = "192.168.0.202"
# Массив виртмашин
virt_machines=[
  {
    :hostname => "exporter-1",
    :ip => HOST_EXPORTER_ONE_IP
  },
  {
    :hostname => "exporter-2",
    :ip => HOST_EXPORTER_TWO_IP
  },
  {
    :hostname => "prometheus",
    :ip => "192.168.0.200"
  },
  {
    :hostname => "grafana",
    :ip => "192.168.0.199"
  }
]

# Show VM GUI
# Показывать гуй виртмашины
HOST_SHOW_GUI = false 

# VM RAM
# Оперативная память ВМ
HOST_MEMMORY = "1024" 

# VM vCPU
# Количество ядер ВМ
HOST_CPUS = 1

# Network adapter to bridge
# В какой сетевой адаптер делать бридж
#HOST_BRIDGE = "Intel(R) Ethernet Connection (2) I219-V" 
HOST_BRIDGE = "Realtek PCIe GBE Family Controller"

# Which box to use
# Из какого бокса выкатываемся
HOST_VM_BOX = "generic/ubuntu2004" 

################################################
# Parameters passed to provision script
# Параметры передаваемые в скрипт инициализации
################################################

# Script to use while provisioning
# Скрипт который будет запущен в процессе настройки
HOST_CONFIIG_SCRIPT = "config.sh" 

# Additional user
# Дополнительный пользователь
HOST_USER = 'test'

# Additional user pass. Root pass will be same
# Пароль дополнительного пользователя. Пароль рута будет таким же
HOST_USER_PASS = '123456789' 

# Run apt dist-upgrade
# Выполнить apt dist-upgrade
HOST_UPGRADE = 'false' 

Vagrant.configure("2") do |config|
	virt_machines.each do |machine|
		config.vm.box = HOST_VM_BOX
		config.vm.define machine[:hostname] do |node|
			node.vm.hostname = machine[:hostname]
			node.vm.network :public_network, bridge: HOST_BRIDGE, ip: machine[:ip]
			node.vm.provider "virtualbox" do |current_vm, override|
				current_vm.name = machine[:hostname]
				current_vm.gui = HOST_SHOW_GUI
				current_vm.memory = HOST_MEMMORY
				current_vm.cpus = HOST_CPUS
				override.vm.provision "shell", path: HOST_CONFIIG_SCRIPT, args: [ 'test', '123456789', 'false', machine[:hostname], machine[:ip], HOST_EXPORTER_ONE_IP, HOST_EXPORTER_TWO_IP], run: "once"
			end
		end
	end
end