# Flux Example

Example GitOps deployments using Flux.

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

Follow the links below for details of tooling installed in the cluster:

* [Flux dashboards](./infrastructure/monitoring/README.md)

* [Litmus Chaos](./tools/litmus/README.md)

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
