# SSHBian Development Guidelines

## Project Overview

SSHBian is a Docker-based VPN solution that creates secure network tunnels using SSH protocol. The project aims to simplify VPN deployment while maintaining security through SSH's proven authentication and encryption mechanisms.

## Architecture Deep Dive

### Current Implementation (v1.0)

#### Core Components

1. **SSH Server Container** (`server-side/Dockerfile`)
   - **Base**: Debian stable-slim for minimal attack surface
   - **SSH Daemon**: OpenSSH server with custom configuration
   - **Network Stack**: Full networking tools suite
   - **Security**: Key-based authentication only

2. **Network Configuration**
   - **TUN Support**: Kernel-level tunnel interfaces enabled
   - **Forwarding**: TCP, UDP, and stream forwarding capabilities
   - **Routing**: Container networking with host bridge access
   - **Firewall**: iptables available for traffic shaping

3. **Authentication System**
   - **Public Key Only**: No password authentication
   - **Root Access**: Direct root login for simplified tunnel creation
   - **Key Management**: Static authorized_keys file

### Technical Implementation Details

#### SSH Configuration (`/etc/ssh/sshd_config`)
```
PermitRootLogin yes
PasswordAuthentication no
PubkeyAuthentication yes
PermitTunnel yes
AllowStreamLocalForwarding yes
AllowTcpForwarding all
GatewayPorts clientspecified
GSSAPIAuthentication no
```

#### Container Networking
- **Privileged Mode**: Required for TUN/TAP interface creation
- **Device Access**: `/dev/net/tun` mapped for tunnel interfaces
- **Capabilities**: `NET_ADMIN` for network administration
- **Port Mapping**: Host port 2222 → Container port 22

#### Available Tools
- **Network Diagnostics**: ping, traceroute, dig, whois, arping
- **Traffic Analysis**: tcpdump, netstat, ss
- **Network Configuration**: ip, ifconfig, route, iptables
- **Development**: git, build-essential, editors (nano, vim)
- **System Monitoring**: htop, ps, top

## Development Workflow

### File Structure
```
sshbian/
├── LICENSE                 # MIT license
├── README.md              # User documentation
├── GUIDELINE.md           # This file - developer reference
└── server-side/
    ├── Dockerfile         # Container definition
    ├── run.sh            # Build and run script
    └── authorized_keys   # SSH public keys
```

### Adding Features

#### 1. Server-Side Modifications
When modifying the SSH server:

1. **Dockerfile Changes**:
   - Add packages to existing `RUN apt-get install` commands
   - Maintain layer efficiency by combining related operations
   - Clean package cache with `apt-get clean` and `rm -rf /var/lib/apt/lists/*`

2. **SSH Configuration**:
   - Modify sshd_config through `sed` commands in Dockerfile
   - Test configuration changes in development container
   - Validate with `sshd -t` before deployment

3. **Security Considerations**:
   - Minimize installed packages to reduce attack surface
   - Use specific package versions when security matters
   - Avoid running additional services unless necessary

#### 2. Client-Side Integration
Future client implementations should:

1. **SSH Client Wrapper**:
   - Abstract SSH tunnel creation
   - Handle TUN interface configuration
   - Manage connection lifecycle

2. **Network Configuration**:
   - Automatic IP assignment (DHCP-like)
   - DNS server configuration
   - Route table management

3. **Connection Management**:
   - Connection health monitoring
   - Automatic reconnection logic
   - Bandwidth and latency monitoring

### Testing Strategy

#### Unit Testing
```bash
# Test container build
docker build -t sshbian-test server-side/

# Test SSH connectivity
ssh -o ConnectTimeout=5 -p 2222 root@localhost echo "Connection OK"

# Test TUN capability
sudo ssh -o Tunnel=point-to-point -o TunnelDevice=any:any -w any:any -p 2222 root@localhost ip link show
```

#### Integration Testing
```bash
# Full VPN connection test
sudo ssh -o Tunnel=point-to-point -o TunnelDevice=0:0 -w 0:0 -p 2222 root@localhost &
sleep 2
ip addr show tun0
ping -c 1 10.0.0.1  # Test connectivity through tunnel
```

#### Security Testing
```bash
# Verify no password authentication
ssh -o PreferredAuthentications=password -p 2222 root@localhost  # Should fail

# Check for unnecessary services
docker exec sshbian-container netstat -tlnp

# Verify container isolation
docker exec sshbian-container ps aux
```

## Planned Features (Roadmap)

### Phase 2: Client Tooling
- **SSH Client Wrapper**: Simplified connection commands
- **Configuration Management**: Connection profiles and settings
- **Cross-Platform Support**: Windows, macOS, Linux clients

### Phase 3: Network Automation
- **DHCP-like IP Assignment**: Automatic client IP configuration
- **DNS Integration**: Automatic DNS server setup
- **Route Management**: Intelligent routing table updates

### Phase 4: Management Interface
- **Web Dashboard**: Connection monitoring and management
- **API Server**: RESTful API for automation
- **Metrics Collection**: Connection statistics and performance data

### Phase 5: Enterprise Features
- **Multi-User Support**: User isolation and permissions
- **Certificate Authority**: Automated key management
- **Load Balancing**: Multiple server instances
- **High Availability**: Failover and redundancy

## Security Considerations

### Current Security Model
- **Container Isolation**: Process and filesystem isolation
- **Network Segmentation**: Controlled container networking
- **Authentication**: Strong public key cryptography
- **Privilege Minimization**: Only necessary capabilities granted

### Security Enhancements (Future)
- **Certificate-Based Auth**: Short-lived certificates instead of static keys
- **Network Policies**: Fine-grained traffic filtering
- **Audit Logging**: Comprehensive connection and activity logs
- **Intrusion Detection**: Automated threat detection

## Known Issues and Limitations

### Current Limitations
1. **Manual Configuration**: TUN interfaces require manual setup
2. **Single User**: Only root user supported currently
3. **No Persistence**: Container data not persistent across restarts
4. **Basic Monitoring**: Limited connection health visibility
5. **Configuration Hardcoded**: SSH config embedded in Dockerfile

### Technical Debt
1. **Dockerfile Optimization**: Multi-stage builds for smaller images
2. **Configuration Management**: External config files
3. **Error Handling**: Improved error messages and diagnostics
4. **Documentation**: More comprehensive examples and tutorials

## Development Standards

### Code Style
- **Shell Scripts**: Follow ShellCheck recommendations
- **Dockerfile**: Use multi-stage builds and .dockerignore
- **Documentation**: Keep docs synchronized with code changes

### Git Workflow
- **Branch Strategy**: Feature branches for new functionality
- **Commit Messages**: Descriptive, imperative mood
- **Code Review**: All changes reviewed before merge

### Testing Requirements
- **Functional Tests**: All core functionality tested
- **Security Tests**: Authentication and authorization verified
- **Performance Tests**: Connection establishment and throughput
- **Compatibility Tests**: Multiple client environments

## API and Interface Design

### Future CLI Interface
```bash
# Server management
sshbian server start [--port 2222] [--config path/to/config]
sshbian server stop
sshbian server status

# Client connections
sshbian connect <server> [--profile name]
sshbian disconnect
sshbian status

# Configuration
sshbian config set server.port 2222
sshbian config add-key path/to/key.pub
sshbian config list-profiles
```

### Configuration File Format (Planned)
```yaml
# sshbian.yml
server:
  port: 2222
  host_keys:
    - /etc/ssh/ssh_host_ed25519_key
  
network:
  tun_interface: tun0
  ip_range: "10.8.0.0/24"
  dns_servers:
    - "1.1.1.1"
    - "8.8.8.8"

clients:
  - name: "laptop"
    public_key: "ssh-ed25519 AAAA..."
    ip: "10.8.0.10"
  
security:
  max_sessions: 10
  idle_timeout: 3600
  require_certificates: false
```

## Debugging and Troubleshooting

### Container Debugging
```bash
# Access running container
docker exec -it sshbian-container /bin/bash

# View SSH logs
docker logs sshbian-container

# Check SSH daemon status
docker exec sshbian-container systemctl status ssh

# Network interface inspection
docker exec sshbian-container ip addr show
```

### Client-Side Debugging
```bash
# Verbose SSH connection
ssh -vvv -p 2222 root@localhost

# Check TUN interface creation
ip link show | grep tun

# Monitor tunnel traffic
sudo tcpdump -i tun0

# Test tunnel connectivity
ping -I tun0 8.8.8.8
```

### Network Troubleshooting
```bash
# Check routing table
ip route show

# Verify packet forwarding
sysctl net.ipv4.ip_forward

# Monitor connection states
ss -tuln | grep 2222

# Check firewall rules
iptables -L -n -v
```

## Performance Optimization

### Current Performance Characteristics
- **Connection Establishment**: ~200ms average
- **Throughput**: Limited by SSH encryption overhead
- **Latency**: ~10-50ms additional latency
- **Resource Usage**: ~50MB RAM, minimal CPU

### Optimization Opportunities
1. **SSH Configuration**: Faster ciphers for high-throughput scenarios
2. **Container Resources**: Memory and CPU limits optimization
3. **Network Buffer Tuning**: TCP buffer size optimization
4. **Compression**: SSH compression for low-bandwidth connections

## Contribution Guidelines

### Before Contributing
1. Read this guideline completely
2. Understand the security model
3. Test changes in isolated environment
4. Document any configuration changes

### Development Environment Setup
```bash
# Development container
docker run --rm -it --privileged --device=/dev/net/tun --name sshbian-dev -p 2222:22 --cap-add=NET_ADMIN sshbian-server /bin/bash

# Test SSH connectivity
ssh -o StrictHostKeyChecking=no -p 2222 root@localhost

# Monitor logs during development
docker logs -f sshbian-dev
```

### Code Quality Standards
- All shell scripts must pass ShellCheck
- Dockerfile must follow best practices (hadolint)
- Changes must not break existing functionality
- Security implications must be documented

## AI Assistant Instructions

When working on this project:

1. **Always examine existing code** before making changes
2. **Follow the security model** - only defensive security implementations
3. **Test all changes** in development containers
4. **Update documentation** when adding features
5. **Consider backwards compatibility** with existing configurations
6. **Use minimal, focused changes** rather than large refactors
7. **Validate SSH configuration** changes with `sshd -t`
8. **Test network connectivity** after any network-related changes

### Common Tasks for AI

#### Adding Network Tools
```dockerfile
# Add to existing RUN command in Dockerfile
RUN apt-get install -y <new-tool>
```

#### Modifying SSH Configuration
```dockerfile
# Use sed to modify sshd_config
RUN sed -i 's/#?OptionName [a-zA-Z-]+[\s]*$/OptionName newvalue/' /etc/ssh/sshd_config
```

#### Testing Changes
```bash
# Always test after modifications
docker build -t sshbian-test server-side/
docker run --rm --privileged --device=/dev/net/tun --name test -p 2223:22 --cap-add=NET_ADMIN sshbian-test
ssh -p 2223 root@localhost echo "Test OK"
```

Remember: This project prioritizes security and simplicity. Every change should maintain or improve the security posture while keeping the solution lightweight and easy to deploy.