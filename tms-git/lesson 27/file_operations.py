def create_and_read_file():
    """Создает файл test.txt, записывает в него текст и читает его"""
    # Запись в файл
    with open('test.txt', 'w', encoding='utf-8') as file:
        file.write("Это тестовый файл для домашнего задания по программированию")
    
    # Чтение из файла
    with open('test.txt', 'r', encoding='utf-8') as file:
        content = file.read()
        print("Содержимое файла test.txt:")
        print(f'"{content}"')


if __name__ == "__main__":
    create_and_read_file()