### <font color='red'>Preflight - Hardware & Utils</font>  

The following pre-requisites configure Data Catalog 7.1.0

Prerequisites for the DC 7.1.0 server:
* Docker
* Docker Compose
* Docker Registry + UI 

* k3s - Rancher

<font color='teal'>This section is for reference only. These tasks have already been completed.</font>

---

<em>Install Docker / Docker Compose</em>

The following script prepares an Alma (RHEL) 8 server for DC 7.1.0 
Docker Registry is installed with a HTTP connection (insecure).

``run the script:``
```
cd Scripts
sudo ./preflight.sh
```
Note: you may need to change permission: sudo chmod +x pre-flight.sh

--- 

<em>Docker Registry</em>

By default, Docker client uses a secure connection over TLS to upload or download images to or from a private registry. You can use TLS certificates signed by CA or self-signed on Registry server.

The container registry configuration file will need to be modified to allow the use of https (secure) communications.

``create a Docker_Registry:``
```
sudo mkdir Docker-Registry
```

``create certs directory:``
```
cd Docker-Registry
sudo mkdir certs
```

``create certs:``
```
sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout Docker-Registry/certs/registry.key -x509 -days 365 -out Docker-Registry/certs/registry.crt -subj "/CN=dockerhost" -addext "subjectAltName=DNS:data-catalog.skytap.example"
```

``copy certs to Node:``
```
cd Docker-Registry/certs
sudo cp registry.* /etc/pki/tls/certs
sudo update-ca-trust extract
```

``copy certs to Docker:``
```
cd
sudo mkdir -p /etc/docker/certs.d/data-catalog.skytap.example:5000
sudo cp Docker-Registry/certs/registry.* /etc/docker/certs.d/data-catalog.skytap.example:5000
```

``restart docker:``
```
sudo systemctl restart docker
```

``add port to firewalld :``
```
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --reload
```
Note: not required as firewall is disabled (open ports in production).

The Docker Regsitry is installed as a container.

``deploy Registry container:``
```
cd Docker-Registry
docker-compose up -d
```
Note: check that the container is up and running -Visual Studio Code

Docker client always attempts to connect to registries by first using HTTPS. You must configure your Docker client so that it can connect to insecure registries. In your Docker client is not configured for insecure registries, you will see the following error when you attempt to pull or push images to the Registry:  

``Error response from daemon: Get https://data-catlog.skytap.example/v2/users/: dial tcp myregistrydomain.com:443 getsockopt: connection refused.``

Resolution: 
* Ensure the /etc/docker/daemon.json has the IP or FQDN. 
* Ensure all the containers have started. Check containers in Docker section of VSC.

``login into the Registry:``
```
docker login data-catalog.skytap.example:5000
Username: admin
Password: password  
```

```
cd /etc/docker
sudo nano daemon.json
```

``check the entry:``
```
{
"insecure-registries" : ["data-catalog.skytap.example:5000", "0.0.0.0"]
}
```

* finally test that the Docker Regsitry is up and running

  > navigate to: https://data-catalog.skytap.example:8080


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
sudo ./deploy_k3s.sh
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