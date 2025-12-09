# Homelab Architecture

A high-level view of the current setup. This will evolve as we iterate.

```mermaid
flowchart LR
    subgraph Proxmox
      PVE[Proxmox VE Cluster]
      VMCP[Control Plane VMs]
      VMW[Worker VMs]
      PVE --- VMCP
      PVE --- VMW
    end

    subgraph Talos
      TALOSCP[Talos Control Plane]
      TALOSW[Talos Workers]
      VMCP --> TALOSCP
      VMW  --> TALOSW
    end

    subgraph Kubernetes
      API[kube-apiserver]
      CNI[Cilium]
      CSI[Proxmox CSI]
      Sealed[Sealed Secrets]
      Argo[Argo CD]
      API --- CNI
      API --- CSI
      API --- Sealed
      API --- Argo
    end

    subgraph GitOps
      Repo[Git Repo: homelab]
      Repo --> Argo
    end

    subgraph OpenTofu
      Tofu[OpenTofu State & Modules]
      Tofu --> PVE
      Tofu --> VMCP
      Tofu --> VMW
      Tofu --> TALOSCP
      Tofu --> TALOSW
    end

    classDef infra fill:#eef,stroke:#66f,stroke-width:1px;
    classDef kube fill:#efe,stroke:#6c6,stroke-width:1px;
    classDef ops fill:#fee,stroke:#f66,stroke-width:1px;

    class PVE,VMCP,VMW infra
    class TALOSCP,TALOSW infra
    class API,CNI,CSI,Sealed,Argo kube
    class Repo,Tofu ops
```

## Notes
- Proxmox hosts run Talos VMs for control plane and workers.
- OpenTofu provisions Proxmox resources and outputs Talos/Kube configs.
- Kubernetes is bootstrapped with Cilium, Sealed Secrets, and Argo CD.
- Argo CD syncs from this repository for infra/apps.