provider "hcloud" {
  token = var.hetzner_token
}

resource "hcloud_ssh_key" "access-ssh-key" {
  name = "Jessy"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_network" "k8s-network" {
  ip_range = "10.10.0.0/16"
  name = "k8s-network"
}

resource "hcloud_network_subnet" "k8s-subnet" {
  ip_range = "10.10.0.0/24"
  network_id = hcloud_network.k8s-network.id
  network_zone = "eu-central"
  type = "server"
}

resource "hcloud_network_route" "k8s-route" {
  destination = "10.100.1.0/24"
  gateway = "10.10.1.1"
  network_id = hcloud_network.k8s-network.id
}


resource "hcloud_server" "master" {
  image = "ubuntu-20.04"
  name = "k8s-master"
  server_type = "cx21-ceph"
  location = "nbg1"
  ssh_keys = [hcloud_ssh_key.access-ssh-key.id]
}

resource "hcloud_server_network" "master-net" {
  network_id = hcloud_network.k8s-network.id
  server_id = hcloud_server.master.id
  ip = "10.10.0.1"
}

resource "hcloud_server" "nodes" {
  count = var.node_count
  image = "ubuntu-20.04"
  name = "k8s-node-${count.index+1}"
  server_type = "cx11-ceph"
  location = "nbg1"
  ssh_keys = [hcloud_ssh_key.access-ssh-key.id]
}

resource "hcloud_server_network" "nodes-network" {
  count = var.node_count
  network_id = hcloud_network.k8s-network.id
  server_id = element(hcloud_server.nodes.*.id, count.index)
  ip = cidrhost(hcloud_network_subnet.k8s-subnet.ip_range, count.index+2)
}


# resource "hcloud_volume" "k8s-data" {
#   name = "k8s-data"
#   size = 10
#   format = "xfs"
#   automount = true
#   server_id = hcloud_server.master.id
# } 

# output "volume_id" {
#   value = hcloud_volume.k8s-data.id
# }


  # provisioner "remote-exec" {
  #   inline = [
  #    "echo ip addr show | grep inet | awk -F \" \" '{print $NF\"|\"$2}' | grep eth0 | awk '{ print substr( $0, 6, 20 ) }' >> /tmp/public_ip.txt"
  #   ]
  # }

  # Copies the string in content into /tmp/file.log
  # provisioner "file" {
  #   content     = "ami used: ${self.ami}"
  #   destination = "/tmp/file.log"
  # }