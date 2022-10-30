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
  token                    = "y0_AgAAAAAFB4j6AATuwQAAAADSlhucqqU6X_zsRh61zgMVgtmNPBj-G0U"
  service_account_key_file = "/root/yacloud/key.json"
  cloud_id                 = "b1g5h324cthaptno5nqf"
  folder_id                = "b1g2f8n81gpa25g6i9sg"
  zone                     = "ru-central1-a"
}

// Create a new instance

resource "yandex_compute_instance" "default" {
  name        = "test"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "image_id"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.foo.id}"
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "fddi:${file("/home/fddi/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone       = "ru-central1-a"
  network_id = "${yandex_vpc_network.foo.id}"
}
