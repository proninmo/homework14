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

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "f2eei02oardlpedocvan"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "fddi:${file("/home/fddi/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "f2eei02oardlpedocvan"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "fddi:${file("/home/fddi/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}


output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
