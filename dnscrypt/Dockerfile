# Image to begin with
FROM debian:bullseye-slim

# Initial image preparation
RUN apt update && \
	apt upgrade -yq && \
	apt install -yq --no-install-recommends bind9-dnsutils ca-certificates dnscrypt-proxy && \
	# Cleanup and postinstall goodies
	rm -rf /var/lib/apt/lists/* && \
	apt clean

# Add s6-overlay
ADD s6-overlay.tar.xz /

# Copy files into filesystem
COPY root/ /

# Command to check if container is running properly or not
# Very useful if monitoring the health status through tools like Portainer
HEALTHCHECK --interval=2m --timeout=3s --start-period=30s CMD dig @127.0.0.1 google.com || exit 1

# Ports to open
EXPOSE 53/tcp 53/udp

# Start service
CMD ["/init"]
