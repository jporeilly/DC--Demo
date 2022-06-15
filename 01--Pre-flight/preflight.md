## <font color='red'>Data Catalog 7.0.1 Preflight - Hardware & Utils</font>  

The following pre-requisites configure Data Catalog 7.0.1

Prerequisites for the DC 7.0.1 server:
* Docker
* Docker Compose
* Docker Registry + UI 

* k3s - Rancher

<font color='teal'>This section is for reference only. These tasks have already been completed.</font>

---

<em>Install Docker / Docker Compose</em>

The following script prepares an Alma (RHEL) 8 server for DC 7.0.1  
Docker Registry is installed with a HTTP connection (insecure).

``run the script:``
```
cd Scripts
sudo ./pre-flight.sh
```
Note: you may need to change permission: sudo chmod +x pre-flight.sh

--- 

<em>Docker Registry</em>

By default, Docker client uses a secure connection over TLS to upload or download images to or from a private registry. You can use TLS certificates signed by CA or self-signed on Registry server.

``install docker-distribution:``
```
sudo yum install -y docker-distribution
```
``set to auto-start at system boot:``
```
sudo systemctl enable docker-distribution 
```

The container registry configuration file will need to be modified to allow the use of https (secure) communications.

``create certs directory:``
```
sudo mkdir /etc/docker-distribution/certs
```
``create certs:``
```
cd /etc/docker-distribution/certs
sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout /certs/registry.key -x509 -days 365 -out /certs/registry.crt -subj "/CN=dockerhost" -addext "subjectAltName=DNS:data-catalog.skytap.example"
```

``copy certs to Node:``
```
sudo cp registry.* /etc/pki/tls/certs
sudo update-ca-trust extract
```

``edit the file '/etc/docker-distribution/registry/config.yml':``
```
cd
sudo nano /etc/docker-distribution/registry/config.yml
```
``add the following:``
```
version: 0.1
log:
  fields:
    service: registry
storage:
    cache:
        layerinfo: inmemory
    filesystem:
        rootdirectory: /var/lib/registry
    delete:
        enabled: true
http:
    addr: :5000
    tls:
      certificate: /etc/docker-distribution/certs/registry.crt
      key: /etc/docker-distribution/certs/registry.key
    host: https://data-catalog.skytap.example:5000
    relativeurls: false
```

``restart docker:``
```
sudo systemctl restart docker
```
``start Registry:``
```
sudo systemctl start docker-distribution
```

``add port to firewalld :``
```
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --reload
```
Note: not required as firewall is disabled (open ports in production).


``login into the Registry:``
```
docker login localhost:5000
Username: admin
Password: password  
```

``check certs:``
```
openssl s_client -showcerts -connect data-catalog.skytap.example:5000
```

---

<em>Install k3s - Rancher</em> 

K3s is an official CNCF sandbox project that delivers a lightweight yet powerful certified Kubernetes distribution designed for production workloads across resource-restrained, remote locations or on IoT devices.

``run the script:``
```
cd Scripts
./deploy_k3s.sh
```
Note: k3s is installed with Traefik disabled. Not required for single node.

If you're having problems connecting to the node, ensure that the ``/etc/rancher/k3s/k3s.yaml`` has been copied over to the ``~/.kube/config`` and is: ``chown -R dc ``. 


``uninstall Rancher:``
```
cd /usr/local/bin/
sudo ./k3s-uninstall.sh
```

---


<em>.kubectl_aliases</em>  
To save typing out the kubectl commands, in the resources folder there's a kubectl_aliases file which you copy over to your $HOME directory.

<font color='teal'>The .kubectl_alias has been configured.</font>

``add the following to your .bashrc/.zshrc file:``
```
cd 
sudo nano .bashrc
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
```

If you want to print the full command before running it.   

``add this to your .bashrc or .zshrc file:``
```
function kubectl() { echo "+ kubectl $@">&2; command kubectl $@; }
```

For further information:

> browse to: https://github.com/ahmetb/kubectl-aliases

--- 