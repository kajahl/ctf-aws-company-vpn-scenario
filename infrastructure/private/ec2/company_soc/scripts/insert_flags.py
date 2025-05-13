import os
import sys
import base64

print('Wykonywanie skryptu Python dla instancji EC2: company_soc')
module_relative_path = "../infrastructure/private/ec2/company_soc"

# Ścieżka bazowa skryptu
base_path = os.path.abspath(os.path.join(os.path.dirname(__file__)))
scripts_path = os.path.join(base_path, "scripts")
print(scripts_path)
sys.path.append(scripts_path)

from flags import insert_flag_to_file, get_flag, replace_placeholder_in_file # type: ignore

# Ścieżki do plików (relatywne względem lokalizacji skryptu)
relative_path_init = os.path.join(base_path, module_relative_path, "init.sh")
init_path = os.path.abspath(relative_path_init)

relative_files_path = os.path.join(base_path, module_relative_path, "files_ready")

def get_file_path(relative_path: str) -> str:
    """
    Funkcja zwracająca pełną ścieżkę do pliku na podstawie jego relatywnej ścieżki.
    """
    return os.path.abspath(os.path.join(relative_files_path, relative_path))

# Lista flag związanych z EC2:Company_SOC
# E:\github\ctf-aws-company-vpn-scenario\infrastructure\private\ec2\company_soc\files_ready\brute force case\logs.log
flags = [
    {"id": "9", "file": "brute force case/logs.log"},
    {"id": "10", "file": "Data Exfiltration case/investigation_notes.txt"},
    {"id": "11", "file": "Phishing & Credential Harvesting/incident_report.txt"},
    {"id": "12", "file": "Hash comparison/Hashes.txt"},
    {"id": "13", "file": "Users to check/AD_users.txt"},
    {"id": "14", "file": "system_diagnostic/case_37.txt", "base64": True},
    {"id": "15", "file": "brute force case/image3.jpg", "base64": True}
]

# Iteracja po flagach i wstawianie ich do odpowiednich plików
for flag in flags:
    flag_id = flag["id"]
    file_path = get_file_path(flag["file"])

    if "base64" in flag and flag["base64"]:
        placeholder, replacement_value = get_flag(flag["id"])
        replacement_value = base64.b64encode(replacement_value.encode('utf-8')).decode('utf-8')
        replace_placeholder_in_file(file_path, placeholder, replacement_value)
    else:
        print(f"Wstawianie flagi ID={flag_id} do pliku: {file_path}")
        insert_flag_to_file(flag_id, file_path)
