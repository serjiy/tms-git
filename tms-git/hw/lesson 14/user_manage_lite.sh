#!/bin/bash
set -euo pipefail
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
USER_FILE="/var/users"

[[ $EUID -ne 0 ]] && echo -e "${RED}Запускайте от root!${NC}" >&2 && exit 1

echo -e "${YELLOW}Чтение файла $USER_FILE...${NC}"
while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    user=$(echo $line | awk '{print $1}')
    group=$(echo $line | awk '{print $2}')
    [[ -z "$user" || -z "$group" ]] && continue
    
    echo "Создаем: $user -> $group"
    groupadd -f "$group" 2>/dev/null
    if useradd -m -g "$group" "$user" 2>/dev/null; then
        echo -e "${GREEN}Успешно: $user создан${NC}"
    else
        echo -e "${RED}Ошибка: $user не создан${NC}"
    fi
done < "$USER_FILE"
echo -e "${YELLOW}Готово!${NC}"