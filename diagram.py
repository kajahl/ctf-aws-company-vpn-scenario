from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, InternetGateway
from diagrams.aws.security import IAM
from diagrams.aws.storage import S3

with Diagram(
    "CTF EC2 and Subnets",
    show=False,
    filename="ctf_ec2_subnets"
):
    with Cluster("External Subnet\n(192.168.1.0/24)"):
        remote_employee = EC2("Remote Employee")

    with Cluster("Shared Subnet\n(172.20.1.0/24)"):
        shared_eni = EC2("Shared ENI")

    with Cluster("Company Subnet\n(10.0.1.0/24)"):
        company_soc = EC2("Company SOC")
        company_archive = EC2("Company Archive")
        company_employee = EC2("Company Employee")

    company_employee >> shared_eni
    remote_employee >> shared_eni

with Diagram(
    "CTF S3 File Management",
    show=False,
    filename="ctf_s3"
):
    remote_employee = EC2("Remote Employee")
    company_employee = EC2("Company Employee")
    company_soc = EC2("Company SOC")
    company_archive = EC2("Company Archive")

    with Cluster("S3 Bucket"):
        s3_files = [
            S3("files.zip"),
            S3("keys/soc-key.pem"),
            S3("keys/employee-key.pem"),
        ]
        s3_files[0] >> company_employee
        s3_files[0] >> company_soc
        s3_files[0] >> company_archive
        s3_files[0] >> remote_employee
        s3_files[1] >> company_archive
        s3_files[2] >> remote_employee

with Diagram(
    "CTF EC2 SSH Keys",
    show=False,
    filename="ctf_ec2_ssh_keys"
):
    key_ctf = IAM("ctf-key")
    key_employee = IAM("employee-key")
    key_soc = IAM("soc-key")

    remote_employee = EC2("Remote Employee")
    company_employee = EC2("Company Employee")
    company_soc = EC2("Company SOC")

    key_ctf >> remote_employee
    key_employee >> company_employee
    key_soc >> company_soc