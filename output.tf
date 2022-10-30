output "external_ip" {
  value = yandex_compute_instance.ubuntu-20-04-lts-v20220124.network_interface.0.nat_ip_address
}