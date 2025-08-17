# Changelog

All notable changes to the SSHBian project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive README.md with quick start guide and architecture overview
- GUIDELINE.md with detailed development guidelines and roadmap
- CHANGELOG.md for tracking project changes

## [0.1.0] - 2025-08-17

### Added
- Initial project structure and repository setup
- MIT License for open source distribution
- Server-side Docker implementation with Debian stable-slim base
- SSH server configuration with VPN tunnel support
- Essential networking tools installation (ping, dig, traceroute, iproute2)
- Public key authentication setup with authorized_keys support
- TUN interface support for Layer 3 VPN functionality
- SSH daemon configuration with tunnel permissions enabled
- Port forwarding and stream forwarding capabilities
- Container security configuration with minimal required privileges
- Build and deployment script (run.sh) for Docker container management
- .gitignore configuration to exclude sensitive authorized_keys file

### Security Features
- Disabled password authentication (public key only)
- Container isolation with controlled networking capabilities
- Privileged mode limited to TUN interface requirements
- Root login permitted for simplified tunnel management
- GSSAPI authentication disabled for faster connections

### Network Configuration
- SSH server listening on port 22 (mapped to host port 2222)
- TUN tunnel support enabled in SSH configuration
- TCP and stream forwarding allowed
- Gateway ports configurable by clients
- Full networking tool suite for diagnostics and management

### Technical Implementation
- Dockerfile with optimized layer structure and package management
- SSH configuration hardening through sed-based modifications
- Essential development tools (git, build-essential, editors)
- System monitoring tools (htop, process utilities)
- Network diagnostic capabilities (arping, traceroute, whois)

### Known Limitations
- Manual TUN interface configuration required on client side
- No automatic IP assignment or DHCP-like functionality
- Single user support (root only)
- No persistent storage across container restarts
- No connection management or health monitoring utilities
- Configuration embedded in Dockerfile (not externalized)

### Development Setup
- Docker-based development environment
- Build script for automated container creation
- Container networking with required capabilities (NET_ADMIN)
- Device mapping for /dev/net/tun access

---

## Version History Notes

### Versioning Strategy
- **Major versions (x.0.0)**: Breaking changes to API or configuration
- **Minor versions (0.x.0)**: New features and enhancements
- **Patch versions (0.0.x)**: Bug fixes and security updates

### Release Process
1. Update version in relevant files
2. Update CHANGELOG.md with new features and fixes
3. Create git tag with version number
4. Build and test Docker image
5. Update documentation if needed

### Future Release Planning
- **v0.2.0**: Client-side tooling and connection automation
- **v0.3.0**: Network configuration automation and IP management
- **v0.4.0**: Web management interface and monitoring
- **v1.0.0**: Full feature set with enterprise capabilities