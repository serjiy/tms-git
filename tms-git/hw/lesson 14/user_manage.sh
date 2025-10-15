#!/bin/bash

# user_manage.sh — управление пользователями и группами

set -euo pipefail  # Безопасный режим

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Конфигурация
readonly USER_FILE="/var/users"
readonly LOG_FILE="/var/log/user_manage.log"

# Проверка root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Ошибка: Этот скрипт должен запускаться от root.${NC}" >&2
        exit 1
    fi
}

# Логирование
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

# Проверка существования пользователя
user_exists() {
    id "$1" &>/dev/null
}

# Проверка существования группы
group_exists() {
    getent group "$1" &>/dev/null
}

# Функция создания пользователя и группы
create_user() {
    local username="$1"
    local groupname="$2"
    
    # Валидация входных данных
    if [[ -z "$username" || -z "$groupname" ]]; then
        log "Ошибка: Пустое имя пользователя или группы"
        return 1
    fi
    
    # Проверка существования пользователя
    if user_exists "$username"; then
        log "Пользователь $username уже существует"
        return 0
    fi
    
    # Создание группы если не существует
    if ! group_exists "$groupname"; then
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
    local count=0
    local success=0
    
    if [[ ! -f "$USER_FILE" ]]; then
        echo -e "${RED}Файл $USER_FILE не найден${NC}" >&2
        return 1
    fi
    
    if [[ ! -s "$USER_FILE" ]]; then
        echo -e "${YELLOW}Файл $USER_FILE пуст${NC}" >&2
        return 1
    fi
    
    log "Начало массового создания пользователей из $USER_FILE"
    
    local oldIFS=$IFS
    local line_count=0
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        ((line_count++))
        
        # Пропуск пустых строк и комментариев
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        
        # Разбор строки
        local user group
        user=$(echo "$line" | awk '{print $1}')
        group=$(echo "$line" | awk '{print $2}')
        
        if [[ -z "$user" || -z "$group" ]]; then
            log "Ошибка в строке $line_count: некорректный формат"
            continue
        fi
        
        if create_user "$user" "$group"; then
            ((success++))
        fi
        ((count++))
        
    done < "$USER_FILE"
    
    IFS=$oldIFS
    
    log "Массовое создание завершено: $success/$count пользователей создано успешно"
    echo -e "${GREEN}Создано пользователей: $success/$count${NC}"
}

# Показать созданных пользователей
show_users() {
    echo -e "\n${YELLOW}Список пользователей системы:${NC}"
    cut -d: -f1 /etc/passwd | sort | column
}

# Интерактивное меню
interactive_menu() {
    while true; do
        echo -e "\n${YELLOW}=== Меню управления пользователями ===${NC}"
        PS3="Выберите опцию (1-3): "
        select option in "Добавить пользователя" "Показать всех пользователей" "Выход"; do
            case $REPLY in
                1)
                    echo
                    read -p "Введите имя пользователя: " uname
                    read -p "Введите имя группы: " gname
                    create_user "$uname" "$gname"
                    break
                    ;;
                2)
                    show_users
                    break
                    ;;
                3)
                    echo -e "${GREEN}Выход...${NC}"
                    exit 0
                    ;;
                *)
                    echo -e "${RED}Неверный выбор. Выберите 1, 2 или 3.${NC}"
                    break
                    ;;
            esac
        done
    done
}

# Основная функция
main() {
    check_root
    
    echo -e "${YELLOW}Скрипт управления пользователями запущен${NC}"
    log "Запуск скрипта"
    
    if [[ -f "$USER_FILE" && -s "$USER_FILE" ]]; then
        batch_create
    else
        echo -e "${YELLOW}Файл $USER_FILE не найден или пуст. Запуск интерактивного режима.${NC}"
        interactive_menu
    fi
}

# Обработка сигналов
trap 'log "Скрипт прерван"; exit 1' INT TERM

# Запуск основной функции
main "$@"