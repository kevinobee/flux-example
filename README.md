# Flux Example

Example GitOps deployments using Flux.

Deployed Kubernetes cluster contains:

1. GitOps

    * [Flux CD](https://fluxcd.io/) continuous and progressive delivery solution for Kubernetes

1. Infrastructure

    * [Linkerd](https://linkerd.io/) service mesh

    * [MetalLB](https://metallb.org/) bare-metal load balancer

    * [NGinx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

    * Bitnami [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)

    * [Kyverno](https://kyverno.io/) policy management and enforcement

1. Observability

    * Monitoring stack using [Grafana](https://grafana.com/) and [Prometheus](https://prometheus.io/)

    * [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server)

    * [Linkerd Viz](https://linkerd.io/) service mesh and Grafana dashboards

    * Log monitoring and alerting using [Loki](https://grafana.com/oss/loki/)

1. Tools

    * [LitmusChaos](https://litmuschaos.io/) open source Chaos Engineering platform

    * [Trivy-Operator](https://github.com/aquasecurity/trivy-operator) Automated vulnerability scanning for Kubernetes workloads. image scanning and resource misconfiguration discovery

1. Applications

    * [Podinfo](https://github.com/stefanprodan/podinfo) sample microservice application

## Getting Started

Shell scripts are provided to create a Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/) and populate it with infrastructure, tools and a sample application from a GitHub repo.

Run the installation script enter the following command:

```shell
./install.sh
```

The installation script will create and test a multi-node cluster running in Docker containers.

## Flux GitOps Operations

To force Flux to run reconcile the manifests held in the Git repository to the cluster run:

```shell
flux reconcile kustomization flux-system --with-source
```

To view Flux resources use:

```shell
flux get all
```

### Cluster Dependency Tree

View the Flux `Kustomization` dependency tree with:

```shell
flux tree kustomization flux-system --compact
```

### Flux Manifest Locations

Flux manifests are used to deploy and maintain cluster resources.

Manifests within the `./k8s/cluster/` folder are used to bootstrap the cluster.

The `./k8s/infrastructure/source/finalizers` folder contains a `finalizers` Kustomization that is used to ensure all infrastructure resources are deployed before synchronizing application or tool manifests.
