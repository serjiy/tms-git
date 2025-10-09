## 1. Создание рабочего каталога

```bash
mkdir ~/zaytsev_student
cd ~/zaytsev_student
```

## 2. Программа на C

**1.c:**
```c
#include <stdio.h>

int main() {
    printf("HELLO Ubuntu\n");
    return 0;
}
```

Компиляция и запуск:
```bash
gcc 1.c -o 1.exe
./1.exe
```

## 3. Скрипт для вывода аргументов командной строки

**script3.sh:**
```bash
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
```

## 4. Скрипт для поиска файлов по расширению

**script4.sh:**
```bash
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
```

## Опционально:

### 1. Скрипт с циклом for для вывода информации о файлах

**optional1.sh:**
```bash
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
```

### 2. Скрипт для поиска строки в файлах

**optional2.sh:**
```bash
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
```

## Инструкция по использованию:

1. **Сделать все скрипты исполняемыми:**
```bash
chmod +x script3.sh script4.sh optional1.sh optional2.sh
```

2. **Примеры использования скриптов:**

```bash
# Скрипт 3 - вывод аргументов
./script3.sh arg1 arg2 arg3

# Скрипт 4 - поиск файлов по расширению
./script4.sh result.txt /home/user txt

# Опциональный скрипт 1 - информация о файлах
./optional1.sh /home/user

# Опциональный скрипт 2 - поиск строки
./optional2.sh "hello world" /home/user
```

Все скрипты включают проверку аргументов и обработку ошибок для надежной работы.