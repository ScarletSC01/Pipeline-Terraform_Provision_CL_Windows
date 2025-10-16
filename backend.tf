terraform {
  backend "gcs" {
    bucket = "tfstate-chile"   # nombre del bucket donde guardarás el estado
    prefix = "gcp-vm"          # carpeta lógica dentro del bucket
  }
}
