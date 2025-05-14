import os
import shutil
import uuid

# Ścieżka bazowa skryptu (lokalizacja pliku initialize.py)
base_path = os.path.dirname(os.path.abspath(__file__))

# Bucket S3 

unique_id = str(uuid.uuid4())[:8]

# Zapisanie do ../files/s3_unique_id.txt
s3_unique_id_path = os.path.join(base_path, '../files/s3_unique_id.txt')
with open(s3_unique_id_path, 'w') as f:
    f.write(unique_id)

# Utworzenie pliku file-bucket.tf z podmianą placeholdera UNIQUE_ID na unique_id
file_bucket_template_path = os.path.join(base_path, '../infrastructure/s3/file-bucket.ttf')
file_bucket_path = os.path.join(base_path, '../infrastructure/s3/file-bucket.tf')

with open(file_bucket_template_path, 'r') as template_file:
    template = template_file.read()

# Zastąpienie placeholdera UNIQUE_ID w pliku file-bucket.tf
template = template.replace("UNIQUE_ID", unique_id)

# Zapisanie zmodyfikowanego pliku jako file-bucket.tf
with open(file_bucket_path, 'w') as destination_file:
    destination_file.write(template)

# Credentials

credentials_path = ''

user_credentials_path = os.path.expanduser("~/.aws/credentials")
working_directory_credentials_path = os.path.join(base_path, ".aws/credentials")

## Sprawdzenie czy istnieje plik (user)/.aws/credentials
if os.path.exists(user_credentials_path):
    credentials_path = user_credentials_path

## Sprawdzenie czy istnieje plik (cwd)/.aws/credentials
elif os.path.exists(working_directory_credentials_path):
    credentials_path = working_directory_credentials_path

## Nie znaleziono pliku z credentials - wyjście z programu
else:
    print(f'Nie znaleziono pliku credentials w katalogu {user_credentials_path}')
    print(f'Nie znaleziono pliku credentials w katalogu {working_directory_credentials_path}')
    print(f'Utwórz plik credentials w jednym z tych katalogów aby kontynuować')
    exit(1)
    
# Wczytanie pliku credentials
print(f'Znaleziono plik ${credentials_path}')

credentials = open(credentials_path, 'r').readlines()

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
        print(f'Nie znaleziono katalogu {ec2_directory}')

# Generowanie pliku init.sh z init_template.sh
template_init_filename = 'init_template.sh'
destination_init_filename = 'init.sh'
for ec2_directory in ec2_directories:
    template_init_filepath = os.path.join(ec2_directory, template_init_filename)
    destination_init_filepath = os.path.join(ec2_directory, destination_init_filename)
    # Sprawdzenie czy istnieje plik init_template.sh
    if os.path.exists(template_init_filepath):
        # Odczytanie pliku init_template.sh
        with open(template_init_filepath, 'r') as template_file:
            template = template_file.read()
        
        # Zastąpienie placeholdera ___AWS_CREDENTIALS_FILE___ w pliku init_template.sh
        template = template.replace("___AWS_CREDENTIALS_FILE___", ''.join(credentials))
        
        # Zapisanie zmodyfikowanego pliku jako init.sh
        with open(destination_init_filepath, 'w') as destination_file:
            destination_file.write(template)
    else:
        print(f'Nie znaleziono pliku {template_init_filepath}')

# Stworzenie archiwów files.zip dla poszczególnych instancji
source_folder_name = 'files_ready'
scripts_folder_name = 'scripts'
template_folder_name = 'files_template'
destination_filename = 'files.zip'

for ec2_directory in ec2_directories:
    template_folder_path = os.path.join(ec2_directory, template_folder_name)
    source_folder_path = os.path.join(ec2_directory, source_folder_name)

    # Sprawdzenie czy istnieje katalog files_template
    if os.path.exists(template_folder_path):
        # Skopiowanie files_template do files
        if os.path.exists(source_folder_path):
            shutil.rmtree(source_folder_path)  # Usuń istniejący folder files
        shutil.copytree(template_folder_path, source_folder_path)
        print(f'Skopiowano {template_folder_name} do {source_folder_name}')
    else:
        print(f'Nie znaleziono katalogu {template_folder_path}')
        continue

for ec2_directory in ec2_directories:
    scripts_folder_path = os.path.join(ec2_directory, scripts_folder_name)

    # Sprawdzenie, czy istnieje katalog "scripts"
    if os.path.exists(scripts_folder_path) and os.path.isdir(scripts_folder_path):
        # Iteracja przez pliki w katalogu "scripts"
        for file in os.listdir(scripts_folder_path):
            if file.endswith('.py'):  # Wykonuj tylko pliki .py
                script_path = os.path.join(scripts_folder_path, file)
                print(f'Wykonywanie skryptu Python: {script_path}')
                
                # Dynamiczne wykonanie skryptu Python
                with open(script_path, 'r') as script_file:
                    exec(script_file.read())
    else:
        print(f'Nie znaleziono katalogu {scripts_folder_path}')

for ec2_directory in ec2_directories:
    source_folder_path = os.path.join(ec2_directory, source_folder_name)
    destination_filepath = os.path.join(ec2_directory, destination_filename)

    # Sprawdzenie czy istnieje katalog files
    if os.path.exists(source_folder_path):
        # Utworzenie archiwum zip za pomocą shutil
        shutil.make_archive(base_name=destination_filepath.replace('.zip', ''), format='zip', root_dir=source_folder_path)
        print(f'Utworzono archiwum: {destination_filepath}')
    else:
        print(f'Nie znaleziono katalogu {source_folder_path}')