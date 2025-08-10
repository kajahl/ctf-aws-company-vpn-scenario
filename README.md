# CTF AWS Company VPN Scenario

A Capture The Flag (CTF) cybersecurity simulation using AWS infrastructure. This scenario simulates a corporate network environment with remote employees, company servers, and security operations center (SOC) for penetration testing and security training.

## 🏗️ Architecture Overview

| S3 File Management | EC2 and Subnets | EC2 SSH Keys |
|:------------------:|:----------------:|:------------:|
| ![S3 File Management](ctf_s3.png) | ![EC2 and Subnets](ctf_ec2_subnets.png) | ![EC2 SSH Keys](ctf_ec2_ssh_keys.png) |

## 📚 Documentation

### 🇵🇱 Polish Documentation / Dokumentacja polska

#### Dla prowadzących
- **[Przewodnik dla prowadzących](docs/pl/for_host.md)** - Kompletny przewodnik konfiguracji i administracji
  - Konfiguracja infrastruktury z Terraform
  - Lokalizacje flag i rozwiązania
  - Przewodnik rozwiązywania problemów
  - Dokumentacja skryptów

#### Dla uczestników  
- **[Przewodnik dla uczestników](docs/pl/for_user.md)** - Instrukcja obsługi dla uczestników CTF
  - Opis scenariusza
  - Instrukcje konfiguracji VM
  - Procedury połączenia
  - Przydatne komendy

### 🇬🇧 English Documentation

#### For Hosts
- **[Host Guide (English)](docs/en/for_host.md)** - *Coming soon*

#### For Participants
- **[Participant Guide (English)](docs/en/for_user.md)** - *Coming soon*

## 🚀 Quick Start

1. **Download the VM**: Get the [AWS-CTF-v2.ova](https://drive.google.com/file/d/1FO7rIJOVRkcNJ98Jc_lPHAsHYU2zGBGq/view) file
2. **Import VM**: Import and run the virtual machine
3. **Configure AWS**: Set up your AWS credentials
4. **Initialize**: Run `./init.sh -p` to start the scenario
5. **Connect**: SSH to the provided IP address
6. **Hunt flags**: Find hidden flags throughout the infrastructure

## 🏁 CTF Scenario: "INFILTRATION: SOCnet"

You gain access to a remote employee's workstation and must explore the corporate network to find hidden flags. The environment includes:

- **Remote Employee PC** - Your entry point
- **Company Archive** - File server with historical data  
- **Company SOC** - Security operations center
- **Company Employee** - Standard employee workstation

## 🛠️ Technology Stack

- **Infrastructure**: AWS (EC2, VPC, S3)
- **Automation**: Terraform
- **Operating System**: Ubuntu Linux
- **Network Tools**: SSH, FTP, HTTP
- **Languages**: Python, Bash

## 📋 Requirements

- AWS Account (student accounts supported)
- VirtualBox or VMware
- Basic Linux command line knowledge
- Network security concepts

## 🎯 Learning Objectives

- Network reconnaissance (`nmap`, `ssh`)
- Linux system navigation
- File analysis and searching (`grep`, `find`, `file`)
- Web resource enumeration (`curl`, `wget`)
- FTP protocol usage
- Log analysis
- Base64 decoding

---

**⚠️ Educational Use Only**: This environment is designed for learning cybersecurity concepts in a controlled setting. Do not use these techniques on systems you do not own or have explicit permission to test.