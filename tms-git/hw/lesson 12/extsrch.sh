#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Использование: $0 <выходной_файл> <каталог> <расширение>"
    echo "Пример: $0 result.txt /home/user txt"
    exit 1
fi

output_file="$1"
directory="$2"
extension="$3"

# Убираем точку из расширения если она есть
extension="${extension#.}"

echo "Поиск файлов с расширением .$extension в каталоге $directory"
find "$directory" -type f -name "*.$extension" > "$output_file"

echo "Результаты сохранены в файл: $output_file"
echo "Найдено файлов: $(wc -l < "$output_file")"
