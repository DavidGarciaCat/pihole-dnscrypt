# DNS filtering with Pi-hole + DNSCrypt

Filter unhealthy DNS queries to prevent:

- adware
- malware
- tracking
- telemetry
- fake news
- gambling
- porn
- social media

As per today's date, Docker's Pi-hole version is 5.x.

## Requisites

This project needs the following dependencies:

- Docker + Docker Compose: https://docs.docker.com/engine/install/
- `make` command/binary. Please check how to enable it in your operating system if you don't have it.

## Install and launch

Create a `download.sh` file from the templated version:

```shell
cp s6-overlay/download.sh.tpl
chmod 755 s6-overlay/download.sh
```

Edit the `download.sh` file to set the desired S6 Overlay version and the required server architecture

> Please note I am working with an Apple M1 laptop so I need the `arm` architecture. If you work with an Intel or AMD CPU, then you will probably need the `x86_64` architecture.

Run the `make` command to boot up the system:

```shell
make up
```

It will perform the following actions:

- Download and prepare the required versions of S6 Overlay
- Build and run the DNSCrypt service to perform DNS checks via HTTPS
- Build and run the PiHole service to filter unwanted content

If you ever need to stop the containers, you can use the `make` command again:

```shell
make down
```

## Post-install configuration

Once the system has boot, make sure to change the PiHole password for the one you want:

```
# Login into the PiHole container
docker-compose exec pihole bash

# Change PiHole password
pihole -a -p

# Don't forget to exit the container's bash
exit
```

## Management

After setting your admin password, you will need to set the DNS Crypt service as your primary resolver:

- Browse your server's IP address and log into the system:
  - http://0.0.0.0:8088/admin/ (you will need to type your recently set password)
- Then browse the `Settings` option from the sidebar menu, and click on the `DNS` tab.
- Disable any active `Upstream DNS Servers` service
- Enable the first `Custom Upstream DNS Servers` and set the DNS Crypt IP Address:
  - `172.20.0.3`
- Make sure to save the changes (the `Save` button is at the bottom)

You will also need to add one or more black lists of hosts to prevent their access:

- There is already a pre-loaded list. However it only prevents "adware & malware". You might want to change it by another one:
  - https://github.com/StevenBlack/hosts#list-of-all-hosts-file-variants
- Then browse the `Adlists` option from the sidebar menu.
- Add the URL of the list you want to add (and set a comment for it if needed). Then add it clicking the `Add` button.
- Under the `List of adlists` block, make sure to enable or disable the lists according to your needs.

Persist the changes!!

- Browse the `Tools` option from the sidebar menu, and then click on the `Update Gravity` submenu.
- Click on the `Update` button; otherwise your previous configuration might not be working unless you reboot the containers.

## Enable the DNS filter on your network

If you want to use this service on a specific devices, then configure the DNS server on that device to target your Pi-hole + DNSCrypt server.

If you want to use this service for your entire network, then configure the DNS server on your router or NAT networks to target your Pi-hole + DNSCrypt server.

If this project is not running in a home environment, then you might want to consider booting up two instances of this service in two different servers. This way, you can consider a secondary DNS server in case you run maintenance actions.

## Apple's Private Relay

By default, Pi-hole blocks `Apple Private Relay` connections. It is not possible to allow them through Pi-hole whitelists.

If you wish to allow Apple Private Relay connections, stop the containers (`make down`), and add the following configuration to your Pi-hole config files:

```conf
# pihole/etc-pihole/pihole-FTL.conf

# ...
BLOCK_ICLOUD_PR=false
# ...
```

## Troubleshooting

**ERROR: Pool overlaps with other one on this address space**

The error message you're encountering suggests that the IP address range you specified for the bridge network in Docker overlaps with another existing network. Docker requires unique IP address ranges for each network to avoid conflicts.

Your options are:

1. Update the `docker-compose.yaml` file and assign a new IP Address range; or
2. Update the existing networks if you run more than one Docker project to release the range used in this project

## Resources

Read more about the used tech here:

- **Pi-hole - Network-wide Ad Blocking**
  - https://pi-hole.net/
- **DNSCrypt**
  - https://www.dnscrypt.org/
  - https://en.wikipedia.org/wiki/DNSCrypt
- **Steven Black's hosts blacklists**
  - https://github.com/StevenBlack/hosts
- **S6 Overlay**
  - https://github.com/just-containers/s6-overlay

## Thanks

Special thanks to:

- My friend @KatsuroKurosaki for sharing a base/split implementation of this project, as I used it as a base guide/reference to create this repository
- All the creators and maintainers of `Pi-hole`, `DNSCrypt`, `blacklists` and `S6 Overlay` as this project would no exist without their unvaluable contribution
