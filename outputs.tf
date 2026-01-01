# output to provide ssh command fro better readibility
# ssh -i id_rsa Photossankarshna@external_ip
output "anisble_ip_command" {
    value = "command to connect ssh:ssh -i id_rsa ${var.VM_user}@${google_compute_instance.first-instance["ansible"].network_interface.0.access_config[0].nat_ip}"
}
output "jenkins-master_instance_ip_command" {
    value = "command to connect jenkins-master: ssh -i id_rsa ${var.VM_user}@${google_compute_instance.first-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip}"
}
output "jenkins-slave_instance_ip_command" {
    value = "command to connect jenkins-slave: ssh -i id_rsa ${var.VM_user}@${google_compute_instance.first-instance["jenkins-slave"].network_interface.0.access_config[0].nat_ip}"
}


#display both public and private ips of all instances
output "instance_ip" {
    value = {
        for instance in google_compute_instance.first-instance :
        instance.name => {
            private_ip = instance.network_interface[0].network_ip
            public_ip = instance.network_interface[0].access_config[0].nat_ip
        }
    }
} 

/*
# public ip of ansible
output "ansible_instance_ip" {
    value = google_compute_instance.first-instance["ansible"].network_interface.0.access_config[0].nat_ip
}
# public ip of jenkins-master
output "jenkins_master_instance_ip" {
    value = google_compute_instance.first-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip
}
# public ip of jenkins-slave
output "Jenkins_slave_instance_ip" {
    value = google_compute_instance.first-instance["jenkins-slave"].network_interface.0.access_config[0].nat_ip
} */