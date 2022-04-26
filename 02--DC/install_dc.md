## <font color='red'>LDC 7.0 Preflight - Hardware & Utils</font>




``upload images:``
```
cd Downloads
./ldc-load-images.sh -i ldc-images-7.0.0-rc.7.tar.gz -r localhost:5000
```


```
kubectl create namespace ldc
kubectl get namespace
```

```
helm install ldc ldc-7.0.0-rc.7.tgz --set global.registry=localhost:5000 -f values.yml -n ldc
```