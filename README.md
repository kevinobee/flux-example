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

## Working with Code

### Repository Structure

```text
.
├── apps
├── cluster
│   └── flux-system
├── infrastructure
│   ├── monitoring
│   ├── policy
│   └── service-mesh
└── tools
```

### GitOps Operations

`Kustomization` dependency chain:

```tools -> apps -> infrastructure -> cluster```
