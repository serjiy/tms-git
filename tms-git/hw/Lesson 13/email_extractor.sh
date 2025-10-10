#!/bin/bash

# Регулярное выражение для поиска email-адресов
EMAIL_REGEX='[a-zA-Z0-9._+]\{1,64\}@[a-zA-Z0-9-]\{1,255\}\(\.[a-zA-Z0-9-]\{1,255\}\)*'

# Поиск email-адресов в переданном файле или stdin
if [ $# -eq 0 ]; then
    TEXT=$(cat)
else
    TEXT=$(cat "$1")
fi

echo "$TEXT" | grep -o "$EMAIL_REGEX" | while read email; do
    # Дополнительные проверки
    local_part="${email%@*}"
    domain="${email#*@}"
    
    # Проверка начала и конца local-part
    if [[ "$local_part" =~ ^[._+] || "$local_part" =~ [._+]$ ]]; then
        continue
    fi
    
    # Проверка начала и конца domain
    if [[ "$domain" =~ ^- || "$domain" =~ -$ ]]; then
        continue
    fi
    
    # Проверка на две точки подряд
    if [[ "$email" == *..* ]]; then
        continue
    fi
    
    # Проверка длины
    if [ ${#local_part} -le 64 ] && [ ${#domain} -le 255 ]; then
        echo "$email"
    fi
done