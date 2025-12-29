# creating vpc
resource "google_compute_network" "i27-ecommerce-vpc" {
    name = "i27-ecommerce-vpc"
    auto_create_subnetworks = false
    
}