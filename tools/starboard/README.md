# Starboard

For more information take a look at the [Starboard: The Kubernetes-Native Toolkit for Unifying Security](https://blog.aquasec.com/starboard-kubernetes-tools) blog post from Aqua.

Start the Octant UI by running:

```shell
octant &
```

## Generate Reports

To generate reports you will require the [Starboard CLI](https://aquasecurity.github.io/starboard/v0.15.4/).

### kube-hunter

`kube-hunter` hunts for security weaknesses in Kubernetes clusters.

To generate a [kube-hunter](https://github.com/aquasecurity/kube-hunter) report run:

```shell
kubectl starboard scan kubehunterreports
```
