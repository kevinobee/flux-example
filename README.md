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

Shell scripts are provider to create a Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/) and populate it with infrastructure, tools and a sample application.

Two options exist:

1. A simple Flux Installation from a GitHub repo

1. A Bootstrapped Flux install that has the potential to modify the cluster with Flux updates.

### Flux Install Option

Run the installation script to create a Kubernetes cluster and populate it with infrastructure, tools and a sample application.

```shell
./install.sh
```

The installation script will create and test a multi-node cluster running in Docker containers.

### Flux Bootstrap Option

Using the `flux bootstrap` command you can install Flux on a Kubernetes cluster and configure it to manage itself from a Git repository.

This approach is useful if you have forked this repo you may choose to use the Flux CD [Bootstrap](https://fluxcd.io/docs/installation/#bootstrap) approach of synchronizing your Git repo and the running cluster.

To do so follow the instructions below:

1. Define environment variables to access GitHub:

    ```shell
    export GITHUB_TOKEN=<your-token>
    export GITHUB_USER=<your-username>
    ```

2. Run the bootstrap script:

    ```shell
    ./bootstrap.sh
    ```

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

Dependencies for this repo are shown below:

```text
Kustomization/flux-system/flux-system
├── Kustomization/flux-system/apps
│   └── Kustomization/emojivoto/emojivoto
├── Kustomization/flux-system/infrastructure
│   ├── Kustomization/flux-system/cert-manager
│   ├── Kustomization/flux-system/finalizers
│   ├── Kustomization/flux-system/ingress-nginx
│   ├── Kustomization/flux-system/linkerd
│   ├── Kustomization/flux-system/metallb
│   ├── Kustomization/flux-system/metrics-server
│   ├── Kustomization/flux-system/observability
│   │   ├── HelmRelease/flux-system/kube-prometheus-stack
│   │   ├── HelmRelease/flux-system/loki
│   │   ├── HelmRelease/flux-system/policy-reporter
│   │   ├── HelmRelease/flux-system/promtail
│   │   ├── HelmRepository/flux-system/grafana
│   │   ├── HelmRepository/flux-system/policy-reporter
│   │   └── HelmRepository/flux-system/prometheus-community
│   ├── Kustomization/flux-system/policy
│   └── Kustomization/flux-system/sealed-secrets
│       ├── HelmRelease/flux-system/sealed-secrets
│       └── HelmRepository/flux-system/sealed-secrets
├── Kustomization/flux-system/tools
│   ├── HelmRelease/flux-system/litmuschaos
│   └── HelmRepository/flux-system/litmuschaos
└── GitRepository/flux-system/git-repo
```

### Flux Manifest Locations

Flux manifests are used to deploy and maintain cluster resources.

Manifests within the `./k8s/cluster/` folder are used to bootstrap the cluster.

The `./k8s/infrastructure/source/finalizers` folder contains a `finalizers` Kustomization that is used to ensure all infrastructure resources are deployed before synchronizing application or tool manifests.
