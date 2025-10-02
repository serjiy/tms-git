#!/bin/bash

# This script is used to change file extensions.

# Проверка количества аргументов
if [ $# -ne 2 ]; then
    echo "Ошибка: Необходимо передать два параметра" >&2
    echo "Пример использования: $0 <имя_файла> <новое_расширение>" >&2
    exit 1
fi

original_file="$1"
new_extension="$2"

# Проверка существования исходного файла
if [ ! -f "$original_file" ]; then
    echo "Ошибка: Файл '$original_file' не существует" >&2
    exit 1
fi

# Удаление точки из нового расширения, если она есть
new_extension="${new_extension#.}"

# Извлечение базового имени файла без расширения
base_name="${original_file%.*}"

# Формирование нового имени файла
new_filename="${base_name}.${new_extension}"

# Проверка, не совпадают ли исходное и новое имена файлов
if [ "$original_file" = "$new_filename" ]; then
    echo "Ошибка: Исходное и новое имена файлов совпадают" >&2
    exit 1
fi

# Проверка существования целевого файла
if [ -e "$new_filename" ]; then
    echo "Ошибка: Файл '$new_filename' уже существует" >&2
    exit 1
fi

# Переименование файла с интерактивным режимом (для дополнительной безопасности)
if mv -i "$original_file" "$new_filename" 2>/dev/null; then
    echo "Файл успешно переименован: '$original_file' -> '$new_filename'"
else
    echo "Ошибка при переименовании файла" >&2
    exit 1
fi
