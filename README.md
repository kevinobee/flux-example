# Flux Example

Example GitOps deployments using Flux.

Cluster contains:

1. [Flux CD](https://fluxcd.io/) continuous and progressive delivery solution for Kubernetes.

1. [Linkerd](https://linkerd.io/) service mesh

1. [MetalLB](https://metallb.org/) bare-metal load balancer

1. [NGinx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

1. Monitoring stack using [Grafana](https://grafana.com/) and [Prometheus](https://prometheus.io/)

1. [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server)

1. Bitnami [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)

1. [Kyverno](https://kyverno.io/) policy management and enforcement

1. [LitmusChaos](https://litmuschaos.io/) open source Chaos Engineering platform

1. [Starboard](https://github.com/aquasecurity/starboard) Kubernetes-native toolkit for Security monitoring, image scanning and resource misconfiguration discovery

1. [Octant](https://octant.dev/) developer-centric web interface for inspecting a Kubernetes cluster and its applications

Future features:

1. Log monitoring and alerting using Loki
1. Vertical Pod Autoscaler

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

## Cluster Tools

Run the [scripts/port-forward.sh](./scripts/port-forward.sh) shell script to expose cluster services as forwarded ports on `localhost`.

Follow the links below for details of tooling installed in the cluster:

* [Flux dashboards](./infrastructure/monitoring/README.md)

* [Linkerd UI](./infrastructure/service-mesh/linkerd-viz/README.md)

* [Litmus Chaos](./tools/litmus/README.md)

* [Policy Reporter UI](./infrastructure/policy/policy-reporter/README.md)

* [Starboard](./tools/starboard/README.md)

## Flux Manifests

Flux manifests are used to deploy and maintain cluster resources.

Manifests within the `./cluster/` folder are used to bootstrap the cluster.

The `./infrastructure/finalizers` folder contains a `finalizers` Kustomization that is used to ensure all infrastructure resources are deployed before synchronizing application or tool manifests.

The repository folder structure is:

```text
.
├── apps
│   └── emojivoto
├── cluster
│   └── flux-system
├── infrastructure
│   ├── finalizers
│   ├── ingress-nginx
│   ├── metallb
│   ├── monitoring
│   │   ├── kube-prometheus-stack
│   │   └── monitoring-config
│   ├── policy
│   ├── sealed-secrets
│   └── service-mesh
│       └── linkerd
└── tools
    ├── litmus
    └── starboard
```
