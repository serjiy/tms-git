#!/bin/bash

# This script is designed to select or delete a substring from a given string based on the specified start and end positions.


# Проверка количества аргументов
if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    echo "Использование: $0 <строка> <начальная_позиция> <конечная_позиция> [-d]"
    echo "  -d: удалить подстроку вместо выделения (опционально)"
    exit 1
fi

string="$1"
start="$2"
end="$3"
delete_mode=false

# Проверка, активирован ли режим удаления
if [ $# -eq 4 ]; then
    if [ "$4" = "-d" ]; then
        delete_mode=true
    else
        echo "Ошибка: неверный флаг. Используйте -d для режима удаления."
        exit 1
    fi
fi

# Проверка, что позиции - числа
if ! [[ "$start" =~ ^[0-9]+$ ]] || ! [[ "$end" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: начальная и конечная позиции должны быть положительными числами"
    exit 1
fi

# Проверка, что позиции не меньше 1
if [ "$start" -lt 1 ] || [ "$end" -lt 1 ]; then
    echo "Ошибка: позиции должны быть не меньше 1"
    exit 1
fi

# Проверка корректности диапазона
if [ "$start" -gt "$end" ]; then
    echo "Ошибка: начальная позиция не может быть больше конечной"
    exit 1
fi

# Получение длины строки в символах (поддержка Unicode)
str_length=$(printf "%s" "$string" | wc -m)
if [ "$end" -gt "$str_length" ]; then
    echo "Ошибка: конечная позиция превышает длину строки"
    exit 1
fi

# Выделение или удаление подстроки с поддержкой Unicode
if [ "$delete_mode" = true ]; then
    # Режим удаления: выводим части до и после указанного диапазона
    result=$(printf "%s" "$string" | awk -v start="$start" -v end="$end" '{
        print substr($0, 1, start-1) substr($0, end+1)
    }')
else
    # Режим выделения: выводим только указанный диапазон
    result=$(printf "%s" "$string" | awk -v start="$start" -v end="$end" '{
        print substr($0, start, end-start+1)
    }')
fi

echo "$result"
