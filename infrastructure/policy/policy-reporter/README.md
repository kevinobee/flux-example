# Policy Reporter UI

Expose the service running the Policy Reporter:

```shell
kubectl port-forward service/policy-reporter-policy-reporter-ui 8082:8080 -n policy-reporter
```

Open <http://localhost:8082/> in your browser.

See [Policy Reporter](https://github.com/kyverno/policy-reporter) GitHub repository for more details.
