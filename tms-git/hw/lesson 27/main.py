import os
import multiply_numbers
import file_operations
import directory_operations
import generate_html


def run_all_tasks():
    """Запускает все задания домашней работы"""
    print("=" * 60)
    print("ДОМАШНЕЕ ЗАДАНИЕ №27")
    print("=" * 60)
    
    # Задание 1: Функция multiply_numbers()
    print("\n1. Функция multiply_numbers():")
    print("-" * 30)
    
    # Импортируем и используем функцию
    result = multiply_numbers.multiply_numbers(5, 7)
    print(f"multiply_numbers(5, 7) = {result}")
    print(f"multiply_numbers(2, 3) = {multiply_numbers.multiply_numbers(2, 3)}")
    
    # Задание 2: Работа с файлом test.txt
    print("\n\n2. Работа с файлом test.txt:")
    print("-" * 30)
    file_operations.create_and_read_file()
    
    # Задание 3: Работа с директорией и файлами
    print("\n\n3. Работа с директорией и файлами:")
    print("-" * 30)
    directory_operations.create_directory_and_files()
    
    # Задание 4: Шаблон template.html
    print("\n\n4. Шаблон template.html:")
    print("-" * 30)
    
    # Сначала создаем шаблон template.html
    template_content = '''<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Список пользователей</title>
</head>
<body>
    <h1>Список пользователей</h1>
    <ul>
        <!-- USERS_LIST -->
    </ul>
    <p>Всего пользователей: <!-- USERS_COUNT --></p>
</body>
</html>'''
    
    with open('template.html', 'w', encoding='utf-8') as file:
        file.write(template_content)
    
    print("Шаблон 'template.html' создан")
    
    # Затем генерируем HTML страницу
    generate_html.generate_users_html()
    
    print("\n" + "=" * 60)
    print("Все задания выполнены успешно!")
    print("=" * 60)
    
    # Информация о созданных файлах
    print("\nСозданные файлы и директории:")
    print("  1. test.txt")
    print("  2. mydir/ (с файлами file1.txt, file2.txt, file3.txt)")
    print("  3. template.html")
    print("  4. users.html")


if __name__ == "__main__":
    run_all_tasks()