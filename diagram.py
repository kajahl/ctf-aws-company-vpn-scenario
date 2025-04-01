from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, InternetGateway, ClientVpn
from diagrams.aws.security import IAM

with Diagram("AWS CTF Infrastructure", show=False):
    # Reprezentacja wygenerowanego klucza SSH (AWS Key Pair)
    key_pair = IAM("SSH Key Pair")

    # External Infrastructure
    with Cluster("External Infrastructure\n(VPC: 192.168.0.0/16)"):
        ext_vpc = VPC("External VPC")
        with Cluster("External Subnet\n(192.168.1.0/24)"):
            ext_pc = EC2("External PC\n(OpenVPN, nmap)")
        igw = InternetGateway("Internet Gateway")

    # VPN serwer
    vpn = ClientVpn("VPN Server")
    
    # Company Infrastructure
    with Cluster("Company Infrastructure\n(VPC: 10.0.0.0/16)"):
        company_vpc = VPC("Company VPC")
        with Cluster("Company Subnet\n(10.0.1.0/24)"):
            pc1 = EC2("Company PC #1")
            pc2 = EC2("Company PC #2")
            pc3 = EC2("Company PC #3")

    # Połączenia między elementami
    key_pair >> ext_pc
    ext_vpc >> ext_pc
    ext_pc >> igw
    ext_pc >> vpn
    vpn >> company_vpc
    company_vpc >> [pc1, pc2, pc3]
