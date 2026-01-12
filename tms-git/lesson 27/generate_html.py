def generate_users_html():
    """Генерирует HTML страницу со списком пользователей"""
    # Список пользователей
    users = [
        {"name": "Иван Иванов", "email": "ivan@example.com"},
        {"name": "Мария Петрова", "email": "maria@example.com"},
        {"name": "Алексей Сидоров", "email": "alexey@example.com"},
        {"name": "Елена Кузнецова", "email": "elena@example.com"},
        {"name": "Дмитрий Васильев", "email": "dmitry@example.com"}
    ]
    
    # Читаем шаблон
    with open('template.html', 'r', encoding='utf-8') as file:
        template = file.read()
    
    # Генерируем строки таблицы с пользователями
    users_rows = ""
    for user in users:
        users_rows += f'            <tr>\n                <td>{user["name"]}</td>\n                <td>{user["email"]}</td>\n            </tr>\n'
    
    # Заменяем плейсхолдеры в шаблоне
    html_content = template.replace(
        '            <!-- Пользователи будут вставлены здесь -->', 
        users_rows.strip()
    )
    html_content = html_content.replace(
        '<!-- Количество будет вставлено здесь -->', 
        str(len(users))
    )
    
    # Сохраняем результат
    with open('users.html', 'w', encoding='utf-8') as file:
        file.write(html_content)
    
    print("HTML страница с пользователями сохранена в файл 'users.html'")
    
    # Выводим результат на экран
    print("\nСодержимое HTML страницы:")
    print("=" * 50)
    print(html_content)


if __name__ == "__main__":
    generate_users_html()