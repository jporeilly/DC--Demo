## <font color='red'>LDC 7.0 Preflight - Hardware & Utils</font>  

The following pre-requisites configure the Data Catalog 7.0.

Prerequisites for the LDC 7.0 machine:
* Docker
* Docker Compose 
* Harbor

* k3s - Rancher

<font color='teal'>This section is for reference only. These tasks have already been completed.</font>

---

<em>Install Docker & Harbor</em>  

The following script prepares an Ubuntu 20.04 machine for LDC 7.0 - including Harbor and Chartmuseum.  
This script installs Harbor with an HTTP connection, Clair, and the Chart Repository Service. It does not install Notary, which requires HTTPS.  

``run the script:``
```
sudo ./pre-requisites.sh
```
Select whether to deploy Harbor using the IP address or FQDN of the host machine.

This is the address at which you access the Harbor interface and the registry service.

* IP address, enter 1.  
* FQDN, enter 2.  

``enter option 2:``  

When the script reports Harbor Installation Complete, log in to your new Harbor instance.

  > browse to: http://ldc.skytap.example

User name: admin  
Password: Harbor12345  

If you wish to enable HTTPS and Notary: 

  > for further details: https://goharbor.io/docs/2.0.0/install-config/configure-https/

--- 

<em>Push & Pull Images to/from Harbor</em>

Once logged in, you should be able to create new projects, pull and push images into Harbor. 

``log in to Harbor with CLI:``
```
cd harbor
docker ldc.skytap.example
Username: admin
Password: Harbor12345
```
Harbor optionally supports HTTP connections, however the Docker client always attempts to connect to registries by first using HTTPS. If Harbor is configured for HTTP, you must configure your Docker client so that it can connect to insecure registries. In your Docker client is not configured for insecure registries, you will see the following error when you attempt to pull or push images to Harbor:  

```Error response from daemon: Get https://myregistrydomain.com/v1/users/: dial tcp myregistrydomain.com:443 getsockopt: connection refused.```

Resolution: 
* Ensure the /etc/docker/daemon.json has the IP or FQDN. 
* Ensure all the containers have started. Check containers in Docker section of VSC.

```
{
"insecure-registries" : ["myregistrydomain.com:port", "0.0.0.0"]
}
```

``create a new project:``
```
in the UI create a project called 'busybox`
```
Switch back to Terminal.

``pull the image:``
```
docker pull busybox
```
``list the images:``
```
docker images
```
``hello world in container:``
```
docker run busybox echo "hello from busybox"
```
``tag the image:``
```
docker tag busybox:latest ldc.skytap.example/busybox:latest
```
``push to harbor:``
```
docker push ldc.skytap.example/busybox/busybox:latest
```
* Log back into Harbor -> Projects -> Busybox .. 

Let's now see if the image can be pulled.

``remove busybox/busybox:latest container:``
```
docker image rm ldc.skytap.example/busybox/busybox:latest
```
or
use the Harbor UI..
``pull image from Harbor:``
```
docker pull ldc.skytap.example/busybox/busybox
```
Note: it will pull the latest image.

---
