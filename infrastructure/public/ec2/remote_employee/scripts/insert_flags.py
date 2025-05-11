import csv
import os

print('Wykonywanie skryptu Python dla instancji EC2: remote_employee')
module_relative_path = "../infrastructure/public/ec2/remote_employee"

# Ścieżka bazowa skryptu
base_path = os.path.dirname(os.path.abspath(__file__))

# Ścieżki do plików (relatywne względem lokalizacji skryptu)
relative_path_csv = os.path.join(base_path, "../files/flags.csv")
relative_path_init = os.path.join(base_path, module_relative_path, "init.sh")

print(base_path, relative_path_csv, relative_path_init)

# Wczytanie flag z pliku CSV
flags = {}
csv_path = os.path.abspath(relative_path_csv)
if os.path.exists(csv_path):
    with open(csv_path, 'r', encoding='utf-8') as csv_file:
        reader = csv.reader(csv_file, delimiter=';')
        for row in reader:
            flag_id, _, placeholder, value = row
            flags[flag_id] = (placeholder, value)
else:
    print(f"Nie znaleziono pliku CSV: {csv_path}")
    exit(1)

# Pobranie flagi o id=1
flag_id = '1'
if flag_id in flags:
    placeholder, replacement_value = flags[flag_id]
else:
    print(f"Nie znaleziono flagi o id={flag_id} w pliku CSV.")
    exit(1)

# Edycja pliku init.sh
init_path = os.path.abspath(relative_path_init)
if os.path.exists(init_path):
    with open(init_path, 'r', encoding='utf-8') as init_file:
        init_content = init_file.read()

    # Podmiana placeholdera na wartość
    updated_content = init_content.replace(placeholder, replacement_value)

    # Zapisanie zmodyfikowanego pliku
    with open(init_path, 'w', encoding='utf-8') as init_file:
        init_file.write(updated_content)
    print(f"Zaktualizowano plik init.sh: {placeholder} -> {replacement_value}")
else:
    print(f"Nie znaleziono pliku init.sh: {init_path}")
    exit(1)