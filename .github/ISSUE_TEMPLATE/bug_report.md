---
name: Bug Report
about: Create a report to help us improve SSHBian
title: '[BUG] '
labels: ['bug', 'needs-triage']
assignees: ['sadeqn', 'sadeq-n-yazdi']
---

## Bug Description
A clear and concise description of what the bug is.

## To Reproduce
Steps to reproduce the behavior:
1. Go to '...'
2. Run command '...'
3. See error

## Expected Behavior
A clear and concise description of what you expected to happen.

## Actual Behavior
What actually happened instead.

## Environment
**Host System:**
- OS: [e.g. Ubuntu 22.04, macOS 14.0, Windows 11]
- Architecture: [e.g. x86_64, arm64]
- Docker Version: [e.g. 24.0.0]
- SSH Client Version: [e.g. OpenSSH 9.0]

**SSHBian Setup:**
- Version/Commit: [e.g. v0.1.0 or commit hash]
- Container Status: [e.g. running, stopped, error]
- Port Configuration: [e.g. 2222:22]

## Error Logs
```
Paste any relevant log output here:
- Docker container logs
- SSH connection errors
- System error messages
```

## Network Configuration
**Client Network:**
- IP Address: [e.g. 192.168.1.100]
- Network Interface: [e.g. eth0, wlan0]
- Firewall Status: [e.g. enabled/disabled]

**Server Network:**
- Container IP: [e.g. 172.17.0.2]
- Port Binding: [e.g. 0.0.0.0:2222]
- TUN Interface: [e.g. tun0 status]

## SSH Connection Details
```bash
# Command used to connect
ssh -vvv -p 2222 root@hostname

# Any specific SSH options or configuration
```

## Additional Context
Add any other context about the problem here:
- Screenshots if applicable
- Related issues or discussions
- Workarounds you've tried
- Impact on your use case

## Checklist
- [ ] I have searched for existing issues
- [ ] I have included all relevant environment details
- [ ] I have provided reproduction steps
- [ ] I have included error logs/output
- [ ] I have tested with the latest version