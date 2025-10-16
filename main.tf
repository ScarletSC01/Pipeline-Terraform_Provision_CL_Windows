resource "google_compute_instance" "vm_instance" {
  name         = "demo-instance-${var.country}"
  machine_type = var.vm_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = lookup({
        "windows-2016" = "windows-cloud/windows-server-2016-dc-v20241008"
        "windows-2022" = "windows-cloud/windows-server-2022-dc-v20241008"
        "windows-2025" = "windows-cloud/windows-server-2025-dc-v20241008"
      }, var.os_type, "windows-cloud/windows-server-2022-dc-v20241008")

      size  = var.disk_size
    }
  }

  network_interface {
    network    = var.network_interface
    subnetwork = var.network_subnet
    access_config {
      nat_ip = var.enable_private_ip == "yes" ? null : "EPHEMERAL"
    }
  }

  metadata = {
    startup-script = var.gitclone_bbk
  }

  tags = split(",", var.fw_rules)
}
