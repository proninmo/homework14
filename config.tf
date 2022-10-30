terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }
}

// Configure the Yandex.Cloud provider
provider "yandex" {
#  token                    = "t1.9euelZrJjM6SyZ3Nm8vKzcaPl8qej-3rnpWaj5WazI-SkJmbm8meyc6Ni8fl8_c6QwZl-e8eaF19_d3z93pxA2X57x5oXX39zef1656Vmo_OlMrOkM2Tmo2JyJHKzpma7_0.2CxWo92opY0n8WoIEwfEa2gw2UT-9_SBzW2X-exfTPQa94h6F_J6B5IEy8EwLf7zOC60sWmzWzGbS8B9F_IsDA"
  service_account_key_file = "/home/fddi/key.json"
  cloud_id                 = "b1g5h324cthaptno5nqf"
  folder_id                = "b1g2f8n81gpa25g6i9sg"
  zone                     = "ru-central1-a"
}

// Create a new instance

data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

resource "yandex_compute_instance" "instance-based-on-coi" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.foo.id}"
    nat = true
  }
  resources {
    cores = 2
    memory = 2
  }
  metadata = {
    docker-container-declaration = file("${path.module}/declaration.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }
}