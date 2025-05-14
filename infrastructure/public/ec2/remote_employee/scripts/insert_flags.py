import os
import sys

print('Wykonywanie skryptu Python dla instancji EC2: remote_employee')
module_relative_path = "../infrastructure/public/ec2/remote_employee"

# Ścieżka bazowa skryptu
base_path = os.path.abspath(os.path.join(os.path.dirname(__file__)))
scripts_path = os.path.join(base_path, "scripts")
print(scripts_path)
sys.path.append(scripts_path)

from flags import insert_flag_to_file, replace_placeholder_in_file # type: ignore

# Ścieżki do plików (relatywne względem lokalizacji skryptu)
relative_path_init = os.path.join(base_path, module_relative_path, "init.sh")
init_path = os.path.abspath(relative_path_init)

# Podmiana S3 Unique ID w pliku init.sh
s3_unique_id_path = os.path.join(base_path, '../files/s3_unique_id.txt')
with open(s3_unique_id_path, 'r') as f:
    s3_unique_id = f.read().strip()

replace_placeholder_in_file(init_path, "UNIQUE_ID", s3_unique_id)

# Dodanie flagi do pliku init.sh

insert_flag_to_file("1", init_path)

# Dodanie flagi do bigosu

relative_files_path = os.path.join(base_path, module_relative_path, "files_ready")

def get_file_path(relative_path: str) -> str:
    """
    Funkcja zwracająca pełną ścieżkę do pliku na podstawie jego relatywnej ścieżki.
    """
    return os.path.abspath(os.path.join(relative_files_path, relative_path))

# Lista flag związanych z EC2:Company_SOC
flags = [
    {"id": "17", "file": "moje/przepisy/bigos.txt"},
    {"id": "18", "file": "firmowe/faktura.txt"}
]

# Iteracja po flagach i wstawianie ich do odpowiednich plików
for flag in flags:
    flag_id = flag["id"]
    file_path = get_file_path(flag["file"])

    print(f"Wstawianie flagi ID={flag_id} do pliku: {file_path}")
    insert_flag_to_file(flag_id, file_path)
