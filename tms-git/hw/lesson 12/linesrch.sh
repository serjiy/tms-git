#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Использование: $0 <строка_для_поиска> <каталог>"
    exit 1
fi

search_string="$1"
directory="$2"

echo "Поиск строки: '$search_string' в каталоге: $directory"
echo "=========================================================="

find "$directory" -type f 2>/dev/null | while read file; do
    if [ -r "$file" ]; then
        if grep -q "$search_string" "$file" 2>/dev/null; then
            file_size=$(stat -c%s "$file" 2>/dev/null || echo "N/A")
            echo "Файл: $file"
            echo "Размер: $file_size байт"
            echo "---"
        fi
    else
        echo "Нет доступа к файлу: $file" >&2
    fi
done 2>/tmp/access_errors

if [ -s /tmp/access_errors ]; then
    echo "Сообщения об ошибках доступа:"
    cat /tmp/access_errors
fi

rm -f /tmp/access_errors
