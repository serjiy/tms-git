import os


def create_directory_and_files():
    """Создает директорию и файлы в ней"""
    # Создание директории
    os.makedirs('mydir', exist_ok=True)
    print("Директория 'mydir' создана")
    
    # Сохраняем текущую директорию
    current_dir = os.getcwd()
    
    # Переход в директорию
    os.chdir('mydir')
    print("Перешли в директорию 'mydir'")
    
    # Создание трех пустых файлов
    file_names = ['file1.txt', 'file2.txt', 'file3.txt']
    for file_name in file_names:
        with open(file_name, 'w', encoding='utf-8') as file:
            pass  # Создаем пустой файл
        print(f"Создан файл: {file_name}")
    
    # Вывод списка файлов в директории
    files = os.listdir('.')
    print("\nСписок файлов в директории 'mydir':")
    for file in sorted(files):
        print(f"  - {file}")
    
    # Возврат в исходную директорию
    os.chdir(current_dir)


if __name__ == "__main__":
    create_directory_and_files()