#create google cloud instances
resource "google_compute_instance" "my-first-vm" {
    name = "my-first-instance"
    machine_type = "e2-medium"
    zone ="us-central1-a"
    
    boot_disk{
        initialize_params{
            image = "debian-cloud/debian-11"
        }

    }
    network_interface {
        network = google_compute_network.i27-ecommerce-vpc.self_link
        subnetwork = google_compute_subnetwork.i27-ecommerce-subnet[0].self_link
    } 
}

# create multiple instance

resource "google_compute_instance" "first-instance" {
    for_each = var.instance 
        name = each.key
        machine_type = each.value.instance_type
        zone = each.value.zone
        boot_disk {
            initialize_params{
                image = data.google_compute_image.my-image.self_link
                size = each.value.disk_size
                type = "pd-standard"
            }
        }
        network_interface {
            network = google_compute_network.i27-ecommerce-vpc.self_link
            subnetwork = each.value.subnet
        }
    
}
# data block for image
data "google_compute_image" "my-image"{
    family = "ubuntu-2204-lts"
    project = "ubuntu-os-cloud"
}