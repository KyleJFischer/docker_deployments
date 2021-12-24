resource "docker_image" "transmission" {
  name = "haugene/transmission-openvpn"
}

resource "docker_container" "transmission" {
  name = "transmission"
  image = docker_image.transmission.latest
  capabilities {
      add = ["NET_ADMIN"]
  }
  devices {
      host_path = "/dev/net/tun"
  }
  restart = "always"
  ports {
          internal = 9091
          external = 9091
  }
  ports {
          internal = 8888
          external = 8888
  }
  dns = [
      "8.8.8.8",
      "8.8.4.4"
  ]
  volumes {
      container_path = "/etc/localtime"
      host_path = "/etc/localtime"
      read_only = true
  }
  volumes {
    container_path = "/data/transmission-home"
    host_path = "${pathexpand("~")}/config/app_config/transmission/"
  }
  volumes {
    container_path = "/data/completed"
    host_path = "${pathexpand("~")}/config/downloads/complete"
  }
  volumes {
    container_path = "/data/incomplete"
    host_path = "${pathexpand("~")}/config/downloads/incomplete"
  }
  volumes {
    container_path = "/data/watch"
    host_path = "${pathexpand("~")}/config/downloads/torrent-blackhole"
  }
  env = [
      "OPENVPN_PROVIDER=NORDVPN",
      "OPENVPN_USERNAME=username",
      "OPENVPN_PASSWORD=password",
      "OPENVPN_OPTS=--inactive 3600 --ping 10 --ping-exit 60",
      "LOCAL_NETWORK=192.168.86.0/24"
	]
}

# resource "docker_image" "transmission_proxy" {
#   name = "haugene/transmission-openvpn-proxy"
# }

# resource "docker_container" "transmission_proxy" {
#     name = "transmission_proxy"
#     image = docker_image.transmission_proxy.latest
#     links = [docker_container.transmission.name]
#     ports {
#         internal = 8080
#         external = 8080
#     }
#     volumes {
#         container_path = "/etc/localtime"
#         host_path = "/etc/localtime"
#         read_only = true
#     }
# }
