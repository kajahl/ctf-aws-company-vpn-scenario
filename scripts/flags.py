import csv
import os

def get_flags():
    base_path = os.path.dirname(os.path.abspath(__file__))

    # Ścieżki do plików (relatywne względem lokalizacji skryptu)
    relative_path_csv = os.path.join(base_path, "../files/flags.csv")

    # Wczytanie flag z pliku CSV
    flags = {}
    csv_path = os.path.abspath(relative_path_csv)
    if os.path.exists(csv_path):
        with open(csv_path, 'r', encoding='utf-8') as csv_file:
            reader = csv.reader(csv_file, delimiter=';')
            for row in reader:
                flag_id, _, placeholder, value = row
                flags[flag_id] = (placeholder, value)
        return flags
    else:
        print(f"Nie znaleziono pliku CSV: {csv_path}")
        exit(1)

def get_flag(flag_id):
    flags = get_flags()
    if flag_id in flags:
        placeholder, replacement_value = flags[flag_id]
        return placeholder, replacement_value
    else:
        print(f"Nie znaleziono flagi o id={flag_id} w pliku CSV.")
        exit(1)

def replace_placeholder_in_file(file_path, placeholder, replacement_value):
    """
    Podmienia placeholder na wartość w podanym pliku.

    :param file_path: Absolutna ścieżka do pliku.
    :param placeholder: Tekst do zastąpienia.
    :param replacement_value: Wartość, która zastąpi placeholder.
    """
    if os.path.exists(file_path):
        # Odczytanie zawartości pliku
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()

        # Podmiana placeholdera
        updated_content = content.replace(placeholder, replacement_value)

        # Zapisanie zmodyfikowanego pliku
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(updated_content)
        print(f"Zaktualizowano plik: {file_path} ({placeholder} -> {replacement_value})")
    else:
        print(f"Nie znaleziono pliku: {file_path}")
        exit(1)

def insert_flag_to_file(flag_id, file_path):
    """
    Wstawia flagę do pliku na podstawie jej ID.

    :param flag_id: ID flagi.
    :param file_path: Ścieżka do pliku, w którym ma być wstawiona flaga.
    """
    print(f'[*] Wstawianie flagi o id={flag_id} do pliku: {file_path}')
    placeholder, replacement_value = get_flag(flag_id)
    replace_placeholder_in_file(file_path, placeholder, replacement_value)