# turn off hyper-v
bcdedit /set hypervisorlaunchtype off

# vagrant

vagrant box
vagrant box list
vagrant destroy -f

# boxes
https://app.vagrantup.com/boxes/search

provisioning

  config.vm.box = "ubuntu/bionic64"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.network :forwarded_port, guest: 80, host: 4567
  
vagrant ssh - connect to virtual machine
  
vagrant suspend
vagrant halt
vagrant destroy 

linked clone 

ansible, chef, puppet, salt provisioning

multimachine