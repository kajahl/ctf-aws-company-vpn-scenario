import os
import sys

print('Wykonywanie skryptu Python dla instancji EC2: company_archive')
module_relative_path = "../infrastructure/private/ec2/company_archive"

# Ścieżka bazowa skryptu
base_path = os.path.abspath(os.path.join(os.path.dirname(__file__)))
scripts_path = os.path.join(base_path, "scripts")
print(scripts_path)
sys.path.append(scripts_path)

from flags import insert_flag_to_file # type: ignore

# Ścieżki do plików (relatywne względem lokalizacji skryptu)
relative_path_init = os.path.join(base_path, module_relative_path, "init.sh")
init_path = os.path.abspath(relative_path_init)

# insert_flag_to_file("1", init_path)

relative_files_path = os.path.join(base_path, module_relative_path, "files_ready")

def get_file_path(relative_path: str) -> str:
    """
    Funkcja zwracająca pełną ścieżkę do pliku na podstawie jego relatywnej ścieżki.
    """
    return os.path.abspath(os.path.join(relative_files_path, relative_path))

# Flaga [ID=3] w pliku [\configs\firewall_config.txt]
flag_id = "3"
firewall_config_path = get_file_path("configs/firewall_config.txt")
insert_flag_to_file(flag_id, firewall_config_path)
