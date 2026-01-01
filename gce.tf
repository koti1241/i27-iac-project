# generate ssh keys 
resource "tls_private_key" "my-ssh-keys"{
    algorithm = "RSA"
    rsa_bits = "2048"
}

#Save the keys into local 
#save private key to local
resource "local_file" "private-key" {
    content = tls_private_key.my-ssh-keys.private_key_pem
    filename = "${path.module}/id_rsa"
}
#save publice key to local
resource "local_file" "public-key" {
    content = tls_private_key.my-ssh-keys.public_key_openssh
    filename = "${path.module}/id_rsa.pub"
}


#create google cloud instances
/*resource "google_compute_instance" "my-first-vm" {
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
}*/

# create multiple instance

resource "google_compute_instance" "first-instance" {
    for_each = var.instance 
        name = each.key
        machine_type = each.value.instance_type
        zone = each.value.zone
        #boot disk from OS
        boot_disk {
            initialize_params{
                image = data.google_compute_image.my-image.self_link
                size = each.value.disk_size
                type = "pd-standard"
            }
        }
        # network configurations
        network_interface {
            network = google_compute_network.i27-ecommerce-vpc.self_link
            subnetwork = each.value.subnet
            access_config {} #external ip
        }
        #Place public key to VMs
        metadata = {
            #username:public-key
            ssh-keys = "${var.VM-user}:${tls_private_key.my-ssh-keys.public_key_openssh}"

        }
        # connection block  to connect  to the instance
        connection {
            host = self.network_interface[0].access_config[0].nat_ip
            type = "ssh"
            user =  var.VM-user
            private_key = tls_private_key.my-ssh-keys.private_key_pem
        }
        # Provisiner block to copy file from local to remote machine
        provisioner "file" {
            source = each.key == "ansible" ? "ansible.sh" : "empty.sh"
            destination = each.key == "ansible" ? "/home/${var.VM-user}/ansible.sh" : "/home/${var.VM-user}/empty.sh"
        }
    
}
# data block for image
data "google_compute_image" "my-image"{
    family = "ubuntu-2204-lts"
    project = "ubuntu-os-cloud"
}

#create fire wall
# we need to open port, 22, 80, 8080, 9000
resource "google_compute_firewall" "my-firewall" {
    name = "my-firewall"
    network = google_compute_network.i27-ecommerce-vpc.name
    allow{
        protocol = "tcp"
        ports = ["80","22","8080","9000"]
    }
    source_ranges = var.source_ranges
}