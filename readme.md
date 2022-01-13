# Prepare

- Crate a namespace first for diff dev
```
 kubectl create namespace dev
```

- Clear all resources in indicated namespace
```
kubectl delete all --all -n <default or any namespace name>
```