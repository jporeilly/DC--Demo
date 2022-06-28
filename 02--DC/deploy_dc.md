### <font color='red'>Installation of Data Catalog 7.1.0</font>

To download the Data Catalog images and Charts, you will need to contact your Account Manager.

* The artifacts are not publicly available.
* To save time, the artifacts have already been downloaded.

`create a dc namespace in k3s:`

```
kubectl create namespace dc
kubectl get namespace
```

`login into the Registry:`

```
docker login data-catalog.skytap.example:5000
Username: admin
Password: password   
```

`upload images:`
```
cd Packages
./ldc-load-images.sh -i ldc-images-7.1.0.tar.gz -r data-catalog.skytap.example:5000
```
Note: Be patient as the images have to be unpacked and then uploaded.

---

<em>Install Data Catalog</em>

`install Data Catalog:`
```
cd Packages
helm install dc ldc-7.1.0.tgz -f values.yml -n dc
```

`check all Pods:`
```
kubectl get all
```

Note: make a note of the dc-agent

---

