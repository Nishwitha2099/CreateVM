resource "tls_private_key" "ssh_key" {
  algorithm   = "RSA"
  rsa_bits = 5089
}

output "tls_private_key" {
    value = tls_private_key.ssh_key.private_key_pem
    sensitive = true
}
