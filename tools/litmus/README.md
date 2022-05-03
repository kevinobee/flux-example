# Litmus ChaosCenter

Expose the `chaos-litmus-frontend-service` by running:

```shell
kubectl -n litmus port-forward svc/chaos-litmus-frontend-service 9091:9091
```

Access the Chaos Center in a browser from <http://localhost:9091/>

The __default credentials__ are:

```text
Username: admin
Password: litmus
```
