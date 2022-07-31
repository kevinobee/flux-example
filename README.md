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

    * Log monitoring and alerting using [Loki](https://grafana.com/oss/loki/)

    * [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server)

    * [Linkerd Viz](https://linkerd.io/) service mesh and Grafana dashboards

1. Tools

    * [LitmusChaos](https://litmuschaos.io/) open source Chaos Engineering platform

    * [Trivy-Operator](https://github.com/aquasecurity/trivy-operator) Automated vulnerability scanning for Kubernetes workloads. image scanning and resource misconfiguration discovery

    1. [Octant](https://octant.dev/) CLI provides a developer-centric web interface for inspecting a Kubernetes cluster and its applications

1. Applications

    * [EmojiVoto](https://github.com/BuoyantIO/emojivoto) sample microservice application

## Getting Started

Before running `./install.sh` define environment variables to access GitHub:

```shell
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
```

Then run the installation script:

```shell
./install.sh
```

The script will create a multi-node cluster running in Docker containers.

## GitOps Operations

To force Flux to run reconcile the manifests held in the Git repository to the cluster run:

```shell
flux reconcile kustomization flux-system --with-source
```

To view Flux resources use:

```shell
flux get all
```

View the Flux `Kustomization` dependency tree with:

```shell
flux tree kustomization flux-system --compact
```

## Flux Manifests

Flux manifests are used to deploy and maintain cluster resources.

Manifests within the `./k8s/cluster/` folder are used to bootstrap the cluster.

The `./infrastructure/source/finalizers` folder contains a `finalizers` Kustomization that is used to ensure all infrastructure resources are deployed before synchronizing application or tool manifests.
