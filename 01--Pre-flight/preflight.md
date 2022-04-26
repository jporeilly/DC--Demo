## <font color='red'>LDC 7.0 Preflight - Hardware & Utils</font>  

The following pre-requisites configure the Data Catalog 7.0.

Prerequisites for the LDC 7.0 machine:
* Docker
* Docker Compose 
* Harbor

* k3s - Rancher

<font color='teal'>This section is for reference only. These tasks have already been completed.</font>

---

<em>Install Docker</em>

The following script prepares an Ubuntu 20.04 machine for LDC 7.0.  
This script installs Docker Registry with an HTTP connection.

``run the script:``
```
sudo ./pre-flight_ldc.sh
```

--- 

<em>Docker Registry</em>

Docker client always attempts to connect to registries by first using HTTPS. You must configure your Docker client so that it can connect to insecure registries. In your Docker client is not configured for insecure registries, you will see the following error when you attempt to pull or push images to Harbor:  

```Error response from daemon: Get https://myregistrydomain.com/v2/users/: dial tcp myregistrydomain.com:443 getsockopt: connection refused.```

Resolution: 
* Ensure the /etc/docker/daemon.json has the IP or FQDN. 
* Ensure all the containers have started. Check containers in Docker section of VSC.

```
{
"insecure-registries" : ["myregistrydomain.com:port", "0.0.0.0"]
}
```

---

<em>Install k3s - Rancher</em> 

K3s is an official CNCF sandbox project that delivers a lightweight yet powerful certified Kubernetes distribution designed for production workloads across resource-restrained, remote locations or on IoT devices.

``run the script:``
```
sudo ./install_k3s.sh
```




---
