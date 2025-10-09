#!/bin/bash

echo "Аргументы командной строки:"
echo "Все аргументы: $@"
echo "Количество аргументов: $#"

echo "Вывод в консоль и файл output.txt:"
for arg in "$@"; do
    echo "$arg"
    echo "$arg" >> output.txt
done

echo "Аргументы сохранены в файл output.txt"
