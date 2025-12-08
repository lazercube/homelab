variable "proxmox" {
  description = "Connection details for the Proxmox cluster"
  type = object({
    name         = string        # human name, e.g. "pve-01"
    cluster_name = string        # Proxmox cluster name, even if single node
    endpoint     = string        # e.g. "https://pve.home:8006"
    insecure     = bool          # true if you're using self-signed TLS
    username     = string        # SSH user, e.g. "root"
    api_token    = string        # PVEAPIToken: <user@realm!tokenid>=<secret>
  })
  sensitive = true
}
