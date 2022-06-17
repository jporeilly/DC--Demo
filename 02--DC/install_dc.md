# Installation of Data Catalog 7.1.0

### Installation of Data Catalog 7.1.0

To download the Data Catalog images and Charts, you will need to contact your Account Manager.

* The artifacts are not publicly available.
* To save time, the artifacts have already been downloaded.

`create a ldc namespace in k3s:`

```
kubectl create namespace ldc
kubectl get namespace
```

`login into the Registry:`

```
docker login data-catalog.skytap.example:5000
Username: admin
Password: password   
```

Note: You can also connect to the Registry via VSC.

`upload images:`

```
cd Packages
./ldc-load-images.sh -i ldc-images-7.1.0.tar.gz -r data-catalog.skytap.example:5000
```

Note: Be patient as the images have to be unpacked and then uploaded.

***

_Install Data Catalog_

`install Data Catalog:`

```
cd Packages
helm install ldc ldc-7.1.0.tgz -f values.yml -n ldc
```

`check all Pods:`

```
kubectl get all
```

Note: make a note of the ldc-agent

***

### Post Installation Tasks

* Copy over postgresql driver

_Copy over Postgres driver to Data Catalog Agent_

`retrive DC Agent Pod name:`

```
kubectl get pods -n ldc
```

`retrieve init-Container name:`

```
kubectl get pod POD_NAME_HERE -n ldc -o jsonpath="{.spec['containers','initContainers'][*].name}"
```

`copy over postgresql driver:`

```
cd Workshop--DC/01--Pre-flight/resources
kubectl cp postgresql-42.3.4.jar ldc/ldc-agent-xxxxx:/opt/ldc/agent/ext --container=agent
```

Note: You can also copy over the driver in MinIO.

***

_MinIO_

MinIO offers high-performance, S3 compatible object storage. Native to Kubernetes, MinIO is the only object storage suite available on every public cloud, every Kubernetes distribution, the private cloud and the edge.

The minIO browser enables you to view the defined storage buckets.

> navigate to: http://data-catalog.skytap.example:30900/minio/login

Access Key: minioadmin\
Secret Key: minioadmin

Note: the keys have been set in the values.yml

```
select: ldc-discovery-cache/ext/jdbc
drag & drop the postgresql-42.3.4.jar onto the canvas
```

Note: these minIO buckets are defined in the values.yml

* ldc: Big Data jar files
* ldc-demo-data: demo data
* ldc-discovery-cache: persistent jdbc drivers
* spark-history: history of spark jobs / events

***
