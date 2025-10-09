#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Использование: $0 <каталог>"
    exit 1
fi

directory="$1"

echo "Размеры и права доступа для файлов в каталоге: $directory"
echo "=========================================================="

find "$directory" -type f -exec ls -lh {} \; 2>/dev/null | while read line; do
    echo "$line"
done
