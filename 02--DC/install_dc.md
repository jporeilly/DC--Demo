## <font color='red'>Installation of Data Catalog 7.0.1</font>

To download the Data Catalog images and Charts, you will need to contact your Account Manager.  
* The artifacts are not publicly available. 
* To save time, the artifacts have already been downloaded.

The local Docker Registry has frontend UI.

  > navigate to: http://data-catalog.skytap.example:8080


``create a ldc namespace in k3s:``
```
kubectl create namespace ldc
kubectl get namespace
```

``login into the Registry:``
```
docker login data-catalog.skytap.example:5000
Username: admin
Password: password   
```
Note: You can also connect to the Registry via VSC.

``upload images:``
```
cd Packages
./ldc-load-images.sh -i ldc-images-7.0.1.tar.gz -r data-catalog.skytap.example:5000
```
Note: Be patient as the images have to be unpacked and then uploaded.

---

<em>Install Data catalog</em>

``install Data Catalog:``
```
cd Packages
helm install ldc ldc-7.0.1.tgz -f values.yml -n ldc
```
``check all Pods:``
```
kubectl get all
```
Note: make a note of the ldc-agent 

---

## <font color='red'>Post Installation Tasks</font>

* Copy over postgresql driver


<em>Copy over Postgres driver to Data Catalog Agent</em>

``retrive DC Agent Pod name:``
```
kubectl get pods -n ldc
```
``retrieve init-Container name:``
```
kubectl get pod POD_NAME_HERE -n ldc -o jsonpath="{.spec['containers','initContainers'][*].name}"
```

``copy over postgresql driver:``
```
cd Workshop--DC/01--Pre-flight/resources
kubectl cp postgresql-42.3.4.jar ldc/ldc-agent-xxxxx:/opt/ldc/agent/ext --container=agent
```
Note: You can also copy over the driver in MinIO.

---

<em>MinIO</em>

MinIO offers high-performance, S3 compatible object storage.
Native to Kubernetes, MinIO is the only object storage suite available on every public cloud, every Kubernetes distribution, the private cloud and the edge.

The minIO browser enables you to view the defined storage buckets.

  > navigate to: http://data-catalog.skytap.example:30900/minio/login

Access Key: minioadmin  
Secret Key: minioadmin

Note: the keys have been set in the values.yml

```
select: ldc-discovery-cache/ext/jdbc
drag & drop the postgresql-42.3.4.jar onto the canvas
```
Note: these minIO buckets are defined in the values.yml
* <font color='teal'>ldc:</font>  Big Data jar files
* <font color='teal'>ldc-demo-data:</font>  demo data
* <font color='teal'>ldc-discovery-cache:</font> persistent jdbc drivers 
* <font color='teal'>spark-history:</font> history of spark jobs / events

---