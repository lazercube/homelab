# Homelab Architecture

Architecture overview of the Homelab setup using Proxmox, Talos, and Kubernetes.

## Infrastructure (Proxmox + Talos)
```mermaid
flowchart LR
  subgraph Proxmox Cluster
    PVE1[Proxmox Node 1]
    PVE2[Proxmox Node 2]
    PVE3[Proxmox Node 3]
  end

  subgraph Talos VMs
    CP1[Control Plane VM]
    CP2[Control Plane VM]
    CP3[Control Plane VM]
    W1[Worker VM]
    W2[Worker VM]
    W3[Worker VM]
  end

  PVE1 --- CP1
  PVE2 --- CP2
  PVE3 --- CP3
  PVE1 --- W1
  PVE2 --- W2
  PVE3 --- W3

  subgraph Kubernetes Layer
    K8s[(Kubernetes Cluster)]
  end

  CP1 --> K8s
  CP2 --> K8s
  CP3 --> K8s
  W1  --> K8s
  W2  --> K8s
  W3  --> K8s
```

Notes
- Proxmox nodes host Talos VMs (control plane and workers).
- The Talos VMs together form the Kubernetes cluster.
- Infra defined in `tofu/` and `tofu/talos/`.

## Kubernetes (Software Components)
```mermaid
flowchart TB
  API[kube-apiserver]
  CNI[Cilium]
  CSI[Proxmox CSI]
  Sealed[Sealed Secrets]
  Argo[Argo CD]

  API --- CNI
  API --- CSI
  API --- Sealed
  API --- Argo

  subgraph GitOps
    Repo[Repo: homelab/kubernetes]
  end
  Repo --> Argo
```

References
- Cilium: `kubernetes/bootstrap/cilium/values.yaml`
- Proxmox CSI: `kubernetes/infra/proxmox-csi/*` and `templates/secrets/proxmox-csi.yaml.tmpl`
- Sealed Secrets: `kubernetes/infra/sealed-secrets/*`
- Argo CD: `kubernetes/infra/argocd/*`