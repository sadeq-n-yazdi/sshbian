# SSHBian - SSH-Based VPN Solution

A lightweight, Docker-based VPN solution that leverages SSH tunneling to create secure VPN connections. This project provides an isolated SSH server environment that enables clients to establish TUN interface connections for VPN functionality over secure SSH connections.

## Overview

SSHBian creates a containerized SSH server that supports:
- SSH tunnel-based VPN connections
- TUN interface creation for network layer VPN
- Secure public key authentication
- Network forwarding and tunneling capabilities
- Isolated container environment for enhanced security

## Quick Start

### Prerequisites
- Docker installed and running
- SSH key pair (Ed25519 recommended)
- Linux/macOS system with root/admin privileges for TUN interface creation

### Server Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd sshbian
   ```

2. **Configure SSH keys:**
   ```bash
   # Copy your public key to the server-side directory
   cp ~/.ssh/id_ed25519.pub server-side/authorized_keys
   ```

3. **Build and run the SSH server:**
   ```bash
   cd server-side
   chmod +x run.sh
   ./run.sh
   ```

The server will be available on port 2222.

### Client Connection

Connect to the VPN server using SSH with TUN interface:

```bash
# Basic SSH connection test
ssh -p 2222 root@localhost

# VPN connection with TUN interface
sudo ssh -o Tunnel=point-to-point -o TunnelDevice=any:any -w any:any -p 2222 root@localhost
```

## Architecture

### Current Implementation (v1)

The current version includes:
- **Docker Container**: Debian-based SSH server with VPN capabilities
- **SSH Configuration**: Secure key-based authentication with tunnel permissions
- **Network Tools**: Pre-installed networking utilities (ping, dig, traceroute, etc.)
- **TUN Support**: Kernel-level tunnel interface support

### Key Components

1. **Dockerfile** (`server-side/Dockerfile`):
   - Debian stable-slim base image
   - SSH server with tunnel permissions enabled
   - Essential networking tools (iproute2, iputils, dnsutils)
   - Security-hardened SSH configuration

2. **Run Script** (`server-side/run.sh`):
   - Automated build and deployment
   - Container lifecycle management
   - Privileged mode for TUN interface access

3. **SSH Configuration**:
   - Public key authentication only
   - TUN interface tunneling enabled
   - TCP/stream forwarding permitted
   - Gateway ports configurable by client

## Security Features

- **No Password Authentication**: Only SSH key-based access
- **Container Isolation**: Isolated environment with minimal attack surface
- **Privileged Operations**: Limited to necessary VPN functionality
- **Network Segmentation**: Containerized network stack

## Network Capabilities

The SSH server supports:
- **TUN Interfaces**: Layer 3 (network layer) VPN tunneling
- **Port Forwarding**: Local and remote port forwarding
- **Stream Forwarding**: Unix socket forwarding
- **Gateway Ports**: Client-specified gateway configuration

## Usage Examples

### Basic VPN Connection
```bash
# Establish VPN tunnel
sudo ssh -o Tunnel=point-to-point -o TunnelDevice=0:0 -w 0:0 -p 2222 root@your-server
```

### Port Forwarding
```bash
# Local port forwarding
ssh -L 8080:localhost:80 -p 2222 root@your-server

# Remote port forwarding  
ssh -R 9090:localhost:3000 -p 2222 root@your-server
```

## Current Limitations

This is version 1 with the following limitations:
- Manual TUN interface configuration required
- No automatic IP assignment
- No DNS configuration automation
- No client-side tooling
- No connection management utilities

## Requirements

### Server Requirements
- Docker Engine
- Linux kernel with TUN/TAP support
- Sufficient privileges for container networking

### Client Requirements
- SSH client with tunnel support
- Root/admin access for TUN interface creation
- Compatible operating system (Linux/macOS/Windows with WSL)

## Development

### Building from Source
```bash
cd server-side
docker build -t sshbian-server .
```

### Running in Development Mode
```bash
# Build and run with debugging
docker run --rm -it --privileged --device=/dev/net/tun --name sshbian-dev -p 2222:22 --cap-add=NET_ADMIN sshbian-server /bin/bash
```

## Troubleshooting

### Common Issues

1. **Permission Denied for TUN Interface**:
   - Ensure running with `sudo` on client
   - Verify `--privileged` and `--cap-add=NET_ADMIN` flags

2. **SSH Connection Refused**:
   - Check if container is running: `docker ps`
   - Verify port mapping: `-p 2222:22`
   - Confirm SSH key in authorized_keys

3. **TUN Interface Creation Failed**:
   - Verify `/dev/net/tun` device availability
   - Check kernel TUN/TAP module: `lsmod | grep tun`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the implementation
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Next Steps

See [GUIDELINE.md](GUIDELINE.md) for detailed development guidelines and planned features.