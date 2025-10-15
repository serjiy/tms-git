#!/bin/bash

set -euo pipefail

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Конфигурация
readonly USER_FILE="/var/users"
readonly LOG_FILE="/var/log/user_manage.log"

# Проверка root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Ошибка: Этот скрипт должен запускаться от root.${NC}" >&2
    exit 1
fi

# Логирование
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

# Функция создания пользователя и группы
create_user() {
    local username="$1"
    local groupname="$2"
    
    echo "Создаем пользователя: $username в группе: $groupname"
    
    # Валидация входных данных
    if [[ -z "$username" || -z "$groupname" ]]; then
        log "Ошибка: Пустое имя пользователя или группы"
        return 1
    fi
    
    # Проверка существования пользователя
    if id "$username" &>/dev/null; then
        log "Пользователь $username уже существует"
        return 0
    fi
    
    # Создание группы если не существует
    if ! getent group "$groupname" &>/dev/null; then
        if groupadd "$groupname"; then
            log "Группа $groupname создана"
        else
            log "Ошибка создания группы $groupname"
            return 1
        fi
    fi
    
    # Создание пользователя
    if useradd -m -g "$groupname" -s "/bin/bash" "$username"; then
        log "Пользователь $username создан в группе $groupname"
        echo -e "${GREEN}Успешно: Пользователь $username создан.${NC}"
        return 0
    else
        log "Ошибка создания пользователя $username"
        echo -e "${RED}Ошибка: Не удалось создать пользователя $username${NC}" >&2
        return 1
    fi
}

# Массовое добавление из файла
batch_create() {
    echo "Начинаем обработку файла $USER_FILE"
    
    local count=0
    local success=0
    
    while IFS= read -r line; do
        ((count++))
        echo "Обрабатываем строку $count: $line"
        
        # Пропуск пустых строк и комментариев
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            echo "Пропускаем строку (пустая или комментарий)"
            continue
        fi
        
        # Разбор строки
        user=$(echo "$line" | awk '{print $1}')
        group=$(echo "$line" | awk '{print $2}')
        
        echo "Разобрано: пользователь='$user', группа='$group'"
        
        if [[ -z "$user" || -z "$group" ]]; then
            echo "Ошибка: некорректный формат строки"
            continue
        fi
        
        if create_user "$user" "$group"; then
            ((success++))
        fi
        echo "---"
        
    done < "$USER_FILE"
    
    echo -e "${GREEN}Создано пользователей: $success/$count${NC}"
    log "Массовое создание завершено: $success/$count пользователей создано успешно"
}

# Основной сценарий
echo -e "${YELLOW}Скрипт управления пользователями запущен${NC}"
log "Запуск скрипта"

if [[ -f "$USER_FILE" && -s "$USER_FILE" ]]; then
    batch_create
else
    echo -e "${YELLOW}Файл $USER_FILE не найден или пуст${NC}"
    exit 1
fi