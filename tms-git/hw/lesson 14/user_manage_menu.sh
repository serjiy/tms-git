#!/bin/bash

# user_manage.sh — управление пользователями и группами

# Проверка root
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт должен запускаться от root."
    exit 1
fi

USER_FILE="/var/users"
oldIFS=$IFS

# Функция создания пользователя и группы
create_user() {
    IFS=$oldIFS
    local username="$1"
    local groupname="$2"
    groupadd -f "$groupname"
    useradd -m -g "$groupname" "$username" && echo "Пользователь $username создан."
}

# Массовое добавление из файла
batch_create() {
    IFS=$'\n'
    for line in $(cat "$USER_FILE"); do
        user=$(echo "$line" | cut -d' ' -f1)
        group=$(echo "$line" | cut -d' ' -f2)
        create_user "$user" "$group"
    done
    IFS=$oldIFS
}

# Интерактивное меню
interactive_menu() {
    while true; do
        select option in "Добавить пользователя" "Показать всех пользователей" "Выход"; do
            case $option in
                "Добавить пользователя")
                    read -p "Имя пользователя: " uname
                    read -p "Группа: " gname
                    create_user "$uname" "$gname"
                    break
                    ;;
                "Показать всех пользователей")
                    cut -d: -f1 /etc/passwd
                    break
                    ;;
                "Выход")
                    exit 0
                    ;;
                *)
                    echo "Выберите опцию 1, 2 или 3."
                    break
                    ;;
            esac
        done
    done
}

# Основной сценарий
if [[ -f "$USER_FILE" && -s "$USER_FILE" ]]; then
    batch_create
else
    interactive_menu
fi
