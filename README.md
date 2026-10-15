# ansible-role-traffic-server

An Ansible Galaxy role to install and configure Apache Traffic Server.

## Supported platforms

- Ubuntu 22.04
- Ubuntu 24.04

## Requirements

- Ansible Core 2.15+
- Docker for Molecule tests

## Variables

| Variable | Default | Description |
|---|---|---|
| traffic_server_package_name | trafficserver | Package name |
| traffic_server_service_name | trafficserver | Service name |
| traffic_server_manage_config | true | Manage HTTP listener |
| traffic_server_config_file | /etc/trafficserver/records.config | Configuration file |
| traffic_server_http_port | 8080 | HTTP listener port |
| traffic_server_service_enabled | true | Enable service at boot |
| traffic_server_service_state | started | Desired service state |

## Example

```yaml
- name: Configure Apache Traffic Server
  hosts: proxies
  become: true
  roles:
    - role: traffic_server
      vars:
        traffic_server_http_port: 8080
```

## Licence
MIT