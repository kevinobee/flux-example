# Monitoring

See [Monitoring with Prometheus](https://fluxcd.io/docs/guides/monitoring/) for full details of how to install Flux Grafana dashboards.

You can access Grafana using port forwarding:

```shell
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
```

The Flux dashboard can be accessed from <http://localhost:3000/d/flux-control-plane>

To log in to the Grafana dashboard, you can use the default credentials:

```text
username: admin
password: prom-operator
```
