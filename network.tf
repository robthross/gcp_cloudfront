# Reserve an external IP
resource "google_compute_global_address" "website" {
  provider = google
  name     = "website-lb-ip"
  depends_on = [
    google_dns_managed_zone.example-zone
  ]
}

# Get the managed DNS zone
data "google_dns_managed_zone" "gcp_dns" {
  provider = google
  name     = "example-zone"
  depends_on = [
    google_dns_managed_zone.example-zone
  ]
}

# Add the IP to the DNS
resource "google_dns_record_set" "website" {
  provider     = google
  name         = "website.${data.google_dns_managed_zone.gcp_dns.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.gcp_dns.name
  rrdatas      = [google_compute_global_address.website.address]
  depends_on = [
    google_dns_managed_zone.example-zone
  ]
}