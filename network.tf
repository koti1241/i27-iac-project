# creating vpc
resource "google_compute_network" "i27-ecommerce-vpc" {
    #name = "i27-ecommerce-vpc"
    name = var.vpc_name
    auto_create_subnetworks = false
    
}
#create subnet 
/*resource "google_compute_subnetwork" "subnet-1" {
    name = "subnet-1"
    #network = "i27-ecommerce-vpc"
    network = google_compute_network.i27-ecommerce-vpc.id
    ip_cidr_range = "10.1.0.0/16"
    region = "us-central1"
}*/
#create subnet 
resource "google_compute_subnetwork" "i27-ecommerce-subnet" {
    count = length(var.subnet)
    name = var.subnet[count.index].name
    #network = "i27-ecommerce-vpc"
    network = google_compute_network.i27-ecommerce-vpc.self_link
    ip_cidr_range = var.subnet[count.index].ip_cidr_range
    region = var.subnet[count.index].region
}

