import os

# Ścieżka bazowa skryptu (lokalizacja pliku clear.py)
base_path = os.path.dirname(os.path.abspath(__file__))

# Katalogi z EC2
ec2_directories = [
    os.path.join(base_path, '../infrastructure/public/ec2'),
    os.path.join(base_path, '../infrastructure/private/ec2'),
]

# Zamiana ścieżek względnych na absolutne
ec2_directories_absolute = [os.path.abspath(path) for path in ec2_directories]

# Wczytanie katalogów z EC2
ec2_directories = []
for ec2_directory in ec2_directories_absolute:
    if os.path.exists(ec2_directory):
        subdirectories = os.listdir(ec2_directory)
        for subdirectory in subdirectories:
            if os.path.isdir(os.path.join(ec2_directory, subdirectory)):
                ec2_directories.append(os.path.join(ec2_directory, subdirectory))
    else:
        print(f"Nie znaleziono katalogu {ec2_directory}")

# Usuwanie plików init.sh i files.zip
files_to_remove = ['init.sh', 'files.zip']
for ec2_directory in ec2_directories:
    for file_name in files_to_remove:
        file_path = os.path.join(ec2_directory, file_name)
        if os.path.exists(file_path):
            os.remove(file_path)
            print(f"Usunięto plik: {file_path}")
        else:
            print(f"Plik nie istnieje: {file_path}")