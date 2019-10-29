# Vagrant exercise

- create new Vagrant project
- you have to create two VMs (multi-machine Vagrantfile, NOT two separate Vagrant projects!)
- name them "ubuntu" and "debian"
- use Ubuntu 18.04 64 bit and Debian 64 bit (last version available, find it yourself
- Ubuntu needs 2 CPUs, 1 GB RAM, connection to the second VM ("debian") 
- in Ubuntu add nginx
- debian VM needs 1 CPU, 1 GB RAM, must have a connection with "ubuntu" VM
- debian and ubuntu VMs must know each other by DNS names "debian" and "ubuntu". so if you go to - for example debian machine and type "ping ubuntu", name ubuntu must be resolved to the proper IP - and ping must be successful (we check network connectivity in that way)
- nginx has a default folder for html pages in /usr/share/nginx/html. Make content available in - under http://mymachineIP/demo URL (Tip: files in /usr/share/nginx/html/demo are published in that - URL
- in Vagrant's project folder on host create a simple static index.html file and open it with a - browser on the host (use IP of the ubuntu VMs)
- create port forwarding of ubuntu VM's port 80 to your laptops port 8080 (Hint: use port - forwarding, after that you can access the file by using  http://localhost:8080/demo 
- Extra: crate a bridged (public) network, test it with accessing it over some other machine in our - network
- package your ubuntu VM into a new box, publish it in Vagrant Cloud
- open a HTTP access to an ubuntu VM running on your laptop and ask your classmate to visit it over - the internet
- More advanced scenarios (all steps must be done automatically, via Vagrantfile, not manually!):

- on ubuntu VM install a web framework you already know (Flask, Django, PHP, ....)
- on debian install mysql and start it and seed some example data into it 
- create (or search for one that's already done) a minimal web project that uses that database
- change the cone of that project with an IDE environment installed on the host (laptop)