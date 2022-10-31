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

  name        = "linux-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8egv6phshj1f64q94n"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    name = "fddi"
    groups = "sudo"
    shell = "/bin/bash"
    sudo = "['ALL=(ALL) NOPASSWD:ALL']"
    ssh-keys = "fddi:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDyVn+C/voNdyZmT+ze221T7DQtAVQ8Ymz3bdiTvyIcsmNzd4yVNZFiAdMbbpEHYg8YnkT7ZASXo7ySk4NFSZQP3yIYmPui79tB5Ok0jYXG8zlA03B0QyIh7VfeKrHxt9QI77detGaRWpdkzGQPf496mmvzHud4XhT4bswurBfzOK5c70eZ9puCz9FNiv33VdKJe8lTu/468LE5R+e4ipz8C8X7f9+sxXLgS/42eZd6scWEU6EKF+WS5x7+yjLKhXUZvrs10fVOIlIym2Lqta4stEugcmX5zC5t1RjHfrHcCxrtmSThGYMYrpCl7o9aESCMLvMnQoVSJoL0MobgEW+Mkg1srGWNZca7B57FfOkRU4VsR9FrpGS49n+vsNA7ObZ9DgvNe0Nok5zK74MPeOybz9ZmZB3eXRXMrJK+eB3MNvkQ2hLDdz96L993IkHaNmvWvT0H8RwUvMitsnMPiINa179Q4h3MX0ZkI7lsJLrtB4fZePP0VH01f8J3mfphQf0= fddi@devops"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.2.0.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}