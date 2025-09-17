`This README was generated and prepared with CURSOR (AI-Assist)`

# Ansible Server Management Setup

This project demonstrates automated server management using Ansible to configure Ubuntu and RedHat-based systems.

## 📁 Project Structure

```
.
├── README.md                 # This file
├── inventory/
│   └── dev/
│       └── hosts.yml        # Inventory with hosts and vars (single source of truth)
├── playbook/
│   └── site.yaml           # Main playbook for server configuration
└── vm/
    ├── ubuntu/
    │   └── Dockerfile      # Docker setup for Ubuntu test VM
    └── redhat/
        └── Dockerfile      # Docker setup for RedHat test VM
```

## 🚀 Quick Start

### Prerequisites

- **Ansible** installed on your local machine
- **Docker** (if using the provided test VMs)
- **SSH access** to target servers

### Installation

1. **Install Ansible:**
   ```bash
   # macOS
   brew install ansible
   
   # Ubuntu/Debian
   sudo apt update && sudo apt install ansible
   
   # RHEL/CentOS
   sudo yum install ansible
   ```

2. **Clone and setup:**
   ```bash
   git clone <repository>
   cd sre-challenges/4-Ansible
   ```

## 🐳 Setting Up Test VMs (Optional)

If you want to test locally using Docker containers (root/rootpass):

1. **Start Ubuntu VM:**
   ```bash
  docker build -t ansible-ubuntu vm/ubuntu/
  docker run -d --name ubuntu-host -p 2222:22 ansible-ubuntu
   ```

2. **Start RedHat VM:**
   ```bash
  docker build -t ansible-redhat vm/redhat/
  docker run -d --name redhat-host -p 2223:22 ansible-redhat
   ```

3. **Verify containers are running:**
   ```bash
   docker ps
   ```

## ⚙️ Configuration

### Inventory Setup (used by this project)

Edit `inventory/dev/hosts.yml` to match your environment. This repository keeps both hosts and variables under `all.vars` so you don't need `group_vars/`:

```yaml
all:
  vars:
    ansible_user: root
    ansible_password: rootpass
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    ubuntu_packages:
      - apache2
    redhat_packages:
      - mariadb-server
      - mariadb
    hello_world_content: "Hello world\n"
    web_server_document_root: "/var/www/html"
    web_server_index_file: "index.html"
  children:
    dev:
      hosts:
        ubuntu:
          ansible_host: 127.0.0.1
          ansible_port: 2222
        redhat:
          ansible_host: 127.0.0.1
          ansible_port: 2223
          ansible_python_interpreter: /usr/bin/python3.9
```

### Variables

Variables are defined inline in `inventory/dev/hosts.yml` under `all.vars` to keep the setup self-contained. You can still move them to `group_vars/` later if you prefer.

## 🎯 What the Playbook Does

The main playbook (`playbook/site.yaml`) performs different tasks based on the target OS:

### Ubuntu Systems:
- ✅ Updates APT package cache
- ✅ Upgrades all packages
- ✅ Installs Apache2 web server
- ✅ Creates a "Hello World" webpage
- ✅ Configures Apache service restart handler

### RedHat Systems:
- ✅ Updates YUM package cache
- ✅ Upgrades all packages
- ✅ Attempts to install MariaDB server
- ✅ Handles DNF module compatibility issues

## 🚀 Deployment

### Test Connection
First, verify Ansible can connect to your servers:

```bash
ansible all -i inventory/dev/hosts.yml -m ping
```

### Run the Playbook
Execute the main playbook:

```bash
ansible-playbook -i inventory/dev/hosts.yml playbook/site.yaml
```

### Run with Verbose Output
For troubleshooting:

```bash
ansible-playbook -i inventory/dev/hosts.yml playbook/site.yaml -v
```

### Run for Specific Hosts
Target only Ubuntu systems:

```bash
ansible-playbook -i inventory/dev/hosts.yml playbook/site.yaml --limit ubuntu
```

Target only RedHat systems:

```bash
ansible-playbook -i inventory/dev/hosts.yml playbook/site.yaml --limit redhat
```

### Run with validation and checks
For checks:

```bash
ansible-playbook -i inventory/dev/hosts.yml playbook/site.yaml --check
```

## 🔧 Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   ```bash
  # Clear stale host keys if containers were rebuilt
  ssh-keygen -R "[127.0.0.1]:2222"; ssh-keygen -R "[127.0.0.1]:2223"
  
  # Test manual SSH connection
  ssh -p 2222 root@127.0.0.1  # Ubuntu container
  ssh -p 2223 root@127.0.0.1  # RedHat container
   ```

2. **Python Interpreter Issues**
   - Ensure the correct Python path is specified in inventory
   - For RedHat systems, use `/usr/bin/python3.9` or adjust as needed

3. **DNF Module Import Error (RedHat)**
   - If you switch to Ansible `package/yum/dnf` modules, ensure the image includes `python3-dnf` or keep using the provided `yum` command tasks.

4. **Undefined variables (`ubuntu_packages`/`redhat_packages`)**
   - Keep the variables in `inventory/dev/hosts.yml` under `all.vars` as shown above.

5. **Package Not Found**
   - Some packages may not be available in all repositories
   - The playbook includes error handling for graceful failures

### Verification

After successful deployment:

1. **Check Ubuntu Apache:**
   ```bash
   curl http://ubuntu_server_ip
   # Should return "Hello world"
   ```

2. **Check services:**
   ```bash
   ansible all -i inventory/dev/hosts.yml -m shell -a "systemctl status apache2" --limit ubuntu
   ```

## 📚 Advanced Usage

### Custom Variables
Create host-specific variables in `host_vars/`:

```bash
mkdir -p host_vars
echo "custom_var: value" > host_vars/ubuntu.yml
```

### Additional Playbooks
Create task-specific playbooks:

```bash
mkdir -p playbook/roles
# Organize complex configurations into roles
```

### Vault for Sensitive Data
Encrypt sensitive information:

```bash
ansible-vault create group_vars/secrets.yml
ansible-playbook -i inventory/dev/hosts.yml playbook/site.yaml --ask-vault-pass
```

## 🏗️ Project Architecture

This setup follows Ansible best practices:
- **Inventory-based** host management
- **OS-specific** task blocks using `ansible_facts['os_family']`
- **Idempotent** operations that can be run repeatedly
- **Error handling** for graceful failures
- **Direct command execution** to avoid Python module dependencies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your environment
5. Submit a pull request

