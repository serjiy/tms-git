#!/bin/bash

# Основная функция проверки email
is_valid_email() {
    local email="$1"
    local local_part="${email%@*}"
    local domain="${email#*@}"
    
    [ ${#local_part} -gt 64 ] && return 1
    [ ${#domain} -gt 255 ] && return 1
    [[ "$local_part" =~ ^[._+] ]] && return 1
    [[ "$local_part" =~ [._+]$ ]] && return 1
    [[ "$domain" =~ ^- ]] && return 1
    [[ "$domain" =~ -$ ]] && return 1
    [[ "$email" == *..* ]] && return 1
    
    return 0
}

# Поиск и фильтрация email-адресов
EMAIL_REGEX='[a-zA-Z0-9._+]\{1,64\}@[a-zA-Z0-9-]\{1,255\}\(\.[a-zA-Z0-9-]\{1,255\}\)*'

if [ $# -eq 0 ]; then
    grep -o "$EMAIL_REGEX" | while read email; do
        is_valid_email "$email" && echo "$email"
    done
else
    grep -o "$EMAIL_REGEX" "$1" | while read email; do
        is_valid_email "$email" && echo "$email"
    done
fi