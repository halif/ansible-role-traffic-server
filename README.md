# Ansible Role: Apache Traffic Server

[![CI](https://github.com/halif/ansible-role-traffic-server/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/halif/ansible-role-traffic-server/actions/workflows/ci.yml)
[![Ansible](https://img.shields.io/badge/Ansible-Ready-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An Ansible role for installing, configuring, and managing **Apache Traffic Server** on supported Ubuntu systems.

The role provides a repeatable way to deploy Traffic Server, manage its configuration, and control the systemd service using Ansible.

## Features

- Installs Apache Traffic Server from the configured APT repositories.
- Validates the target operating system.
- Manages the `records.config` configuration file.
- Configures the HTTP proxy listening port.
- Enables and starts the Traffic Server service.
- Supports configurable defaults and Ansible handlers.
- Includes automated linting and Molecule tests in GitHub Actions.

## Requirements

- Ansible Core
- A supported Ubuntu host
- APT package repositories providing the `trafficserver` package
- Privilege escalation for package installation and system configuration

### Supported platforms

| Operating system | Release | Codename |
|---|---|---|
| Ubuntu | 22.04 LTS | Jammy |
| Ubuntu | 24.04 LTS | Noble |

> Support depends on the availability of the Traffic Server package and its compatibility with the target system.

## Installation

Install the role from Ansible Galaxy, if it has been published there:

```bash
ansible-galaxy role install halif.traffic_server
```

Alternatively, clone the repository:

```bash
git clone https://github.com/halif/ansible-role-traffic-server.git
cd ansible-role-traffic-server
```

## Role variables

The following variables are defined in `defaults/main.yml`.

| Variable | Default | Description |
|---|---|---|
| `traffic_server_package_name` | `trafficserver` | APT package name |
| `traffic_server_service_name` | `trafficserver` | Systemd service name |
| `traffic_server_apt_update_cache` | `true` | Whether to refresh the APT cache |
| `traffic_server_supported_ubuntu_releases` | `jammy`, `noble` | Supported Ubuntu codenames |
| `traffic_server_manage_config` | `true` | Whether to manage the configuration |
| `traffic_server_config_file` | `/etc/trafficserver/records.config` | Configuration file path |
| `traffic_server_port` | `8080` | HTTP proxy listening port |
| `traffic_server_service_enabled` | `true` | Enable the service at boot |
| `traffic_server_service_state` | `started` | Desired service state |

Override defaults in your inventory or playbook as needed.

## Usage

### Basic example

Create a playbook named `site.yml`:

```yaml
---
- name: Configure Apache Traffic Server
  hosts: traffic_servers
  become: true

  roles:
    - role: halif.traffic_server
```

Run the playbook:

```bash
ansible-playbook -i inventory.ini site.yml
```

### Custom configuration

Override the default listening port:

```yaml
---
- name: Configure Apache Traffic Server
  hosts: traffic_servers
  become: true

  roles:
    - role: halif.traffic_server
      vars:
        traffic_server_port: 8081
        traffic_server_service_enabled: true
        traffic_server_service_state: started
```

Make sure your firewall and network configuration allow clients to reach the selected port.

## Inventory example

Create an `inventory.ini` file:

```ini
[traffic_servers]
proxy01 ansible_host=192.0.2.10
```

Replace the example IP address with the address of your target host.

## Testing

This repository uses **yamllint**, **ansible-lint**, and **Molecule** to validate the role.

### Install development dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate

python -m pip install --upgrade pip
pip install ansible-core ansible-lint yamllint molecule
pip install "molecule-plugins[docker]"
```

Docker must be installed and running for Molecule's Docker scenario.

### Run lint checks

```bash
make lint
```

Or run the tools individually:

```bash
yamllint -c .config/yamllint.yml .
ansible-lint
```

### Run Molecule tests

```bash
make molecule
```

Or run Molecule directly:

```bash
molecule test
```

The default scenario creates a Docker-based Ubuntu environment, applies the role, and executes the configured verification steps.

## Continuous integration

GitHub Actions runs the project's quality checks and Molecule scenario.

The workflow is located at:

```text
.github/workflows/ci.yml
```

The pipeline includes:

1. **Lint** — YAML and Ansible lint checks.
2. **Create** — provision the Docker test container.
3. **Converge** — apply the role to the test host.
4. **Idempotence** — check whether a second application introduces unexpected changes.
5. **Verify** — run the scenario's configured assertions.
6. **Cleanup** — remove test resources.

The workflow can be triggered by a push to `master`, a pull request, or a manual dispatch, according to its configuration.

## Project structure

```text
ansible-role-traffic-server/
├── .github/
│   └── workflows/
│       └── ci.yml
├── defaults/
│   └── main.yml
├── handlers/
│   └── main.yml
├── meta/
│   └── main.yml
├── tasks/
│   ├── main.yml
│   ├── install.yml
│   ├── configure.yml
│   └── service.yml
├── templates/
│   └── records.config.j2
├── molecule/
│   └── default/
│       ├── molecule.yml
│       ├── converge.yml
│       └── verify.yml
├── .ansible-lint
├── .gitignore
├── Makefile
├── README.md
└── requirements.yml
```

## Troubleshooting

### The package cannot be found

Verify that the target Ubuntu release is supported and that its APT repositories are configured correctly.

### The service fails to start

Check the service status and logs:

```bash
sudo systemctl status trafficserver
sudo journalctl -u trafficserver -n 100 --no-pager
```

### The proxy is not listening on the expected port

Inspect the configured listening port and the effective Traffic Server configuration. Also check firewall rules and whether another process is using the port.

### Molecule fails in Docker

Verify that Docker is running and that the test container supports the systemd configuration required by the scenario. Review the output of `molecule test` to identify the failing stage.

## Contributing

Contributions, bug reports, and improvements are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Run lint checks and Molecule tests.
5. Submit a pull request.

Please keep changes consistent with Ansible best practices and ensure the CI pipeline passes.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
