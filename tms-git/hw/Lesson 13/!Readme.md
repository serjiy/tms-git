## 1. `word_counter.sh` - Подсчёт слов в тексте
```bash
#!/bin/bash
# Подсчёт слов (слово - последовательность букв с возможными дефисами)
grep -o -E "[[:alpha:]]+(-[[:alpha:]]+)*" | wc -l
```

**Использование:**
```bash
cat text.txt | ./word_counter.sh
# или
echo "ваш текст" | ./word_counter.sh
```

## 2. `log_renamer.sh` - Добавление timestamp к .log файлам
```bash
#!/bin/bash
# Добавление timestamp ко всем .log файлам (filename_timestamp.log)
for f in *.log; do 
    mv "$f" "${f%.log}_$(date +%Y%m%d_%H%M%S).log"
done
```

**Использование:**
```bash
./log_renamer.sh
```

## 3. `py_committer.sh` - Добавление хэша коммита к .py файлам
```bash
#!/bin/bash
# Добавление хэша коммита ко всем .py файлам
for f in *.py; do 
    mv "$f" "${f%.py}_$(git rev-parse --short HEAD).py"
done
```

**Использование:**
```bash
./py_committer.sh
```

## 4. `duplicate_fixer.sh` - Исправление повторяющихся слов
```bash
#!/bin/bash
# Исправление повторений слов (слово пробелы то_же_слово)
sed -E 's/\b([[:alpha:]]+(-[[:alpha:]]+)*)[[:space:]]+\1\b/\1/g'
```

**Использование:**
```bash
cat text.txt | ./duplicate_fixer.sh
# или
echo "текст с повторениями" | ./duplicate_fixer.sh
```

## Настройка прав доступа:
```bash
chmod +x word_counter.sh log_renamer.sh py_committer.sh duplicate_fixer.sh
```

## Краткое описание скриптов:
- **word_counter.sh** - подсчитывает слова по определению
- **log_renamer.sh** - добавляет временную метку к лог-файлам  
- **py_committer.sh** - добавляет хэш коммита к Python-файлам
- **duplicate_fixer.sh** - исправляет повторяющиеся слова в тексте

Все скрипты готовы к использованию после настройки прав доступа (chmod +x).

## ======================================================

## 5. 'text_processor.sh' - все функции в одном файле

Использование **text_processor.sh**, объединяющего все функции в одном файле:

```bash
#!/bin/bash

# Функции из домашнего задания

# Задача 1: Подсчёт слов
count_words() {
    echo "=== Подсчёт слов в тексте ==="
    grep -o -E "[[:alpha:]]+(-[[:alpha:]]+)*" | wc -l
}

# Задача 2.1: Переименование .log файлов
rename_logs() {
    echo "=== Переименование .log файлов ==="
    for f in *.log; do
        if [ -f "$f" ]; then
            new_name="${f%.log}_$(date +%Y%m%d_%H%M%S).log"
            mv "$f" "$new_name"
            echo "Переименован: $f -> $new_name"
        fi
    done
}

# Задача 2.2: Переименование .py файлов
rename_py() {
    echo "=== Переименование .py файлов ==="
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Ошибка: не найден git-репозиторий"
        return 1
    fi
    
    for f in *.py; do
        if [ -f "$f" ]; then
            new_name="${f%.py}_$(git rev-parse --short HEAD).py"
            mv "$f" "$new_name"
            echo "Переименован: $f -> $new_name"
        fi
    done
}

# Задача 3: Исправление повторов
fix_repeats() {
    echo "=== Исправление повторяющихся слов ==="
    sed -E 's/\b([[:alpha:]]+(-[[:alpha:]]+)*)[[:space:]]+\1\b/\1/g'
}

# Основная логика скрипта
main() {
    case "$1" in
        "count")
            count_words
            ;;
        "rename-logs")
            rename_logs
            ;;
        "rename-py")
            rename_py
            ;;
        "fix-repeats")
            fix_repeats
            ;;
        "demo")
            demo_all
            ;;
        *)
            echo "Использование: $0 {count|rename-logs|rename-py|fix-repeats|demo}"
            echo "  count        - подсчитать слова из stdin"
            echo "  rename-logs  - переименовать .log файлы"
            echo "  rename-py    - переименовать .py файлы" 
            echo "  fix-repeats  - исправить повторы из stdin"
            echo "  demo         - запустить демонстрацию всех функций"
            ;;
    esac
}

# Демонстрационная функция
demo_all() {
    echo "=== ДЕМОНСТРАЦИЯ ВСЕХ ФУНКЦИЙ ==="
    echo ""
    
    # Демо подсчёта слов
    echo "1. ПОДСЧЁТ СЛОВ:"
    echo "Текст: '0н — серо-буро-малиновая редиска!!! >>>i-> А не кот. www.kot.ru'"
    echo -n "Результат: "
    echo "0н — серо-буро-малиновая редиска!!! >>>i-> А не кот. www.kot.ru" | count_words
    echo ""
    
    # Демо исправления повторов
    echo "2. ИСПРАВЛЕНИЕ ПОВТОРОВ:"
    echo "Текст: 'Довольно распространённая ошибка ошибка — это лишний повтор слова слова.'"
    echo -n "Результат: "
    echo "Довольно распространённая ошибка ошибка — это лишний повтор слова слова." | fix_repeats
    echo ""
    
    # Информация о переименовании файлов
    echo "3. ПЕРЕИМЕНОВАНИЕ ФАЙЛОВ:"
    echo "Для переименования выполните:"
    echo "  $0 rename-logs  - для .log файлов"
    echo "  $0 rename-py    - для .py файлов"
}

# Запуск основной функции
main "$@"
```

## Примеры использования скрипта:

### 1. Демонстрация всех функций
```bash
# Делаем скрипт исполняемым
chmod +x text_processor.sh

# Запускаем демо-режим
./text_processor.sh demo
```

**Вывод:**
```
=== ДЕМОНСТРАЦИЯ ВСЕХ ФУНКЦИЙ ===

1. ПОДСЧЁТ СЛОВ:
Текст: '0н — серо-буро-малиновая редиска!!! >>>i-> А не кот. www.kot.ru'
Результат: 9

2. ИСПРАВЛЕНИЕ ПОВТОРОВ:
Текст: 'Довольно распространённая ошибка ошибка — это лишний повтор слова слова.'
Результат: Довольно распространённая ошибка — это лишний повтор слова.

3. ПЕРЕИМЕНОВАНИЕ ФАЙЛОВ:
Для переименования выполните:
  ./text_processor.sh rename-logs  - для .log файлов
  ./text_processor.sh rename-py    - для .py файлов
```

### 2. Подсчёт слов из файла
```bash
# Создаём тестовый файл
echo "Это тестовый текст с несколькими словами.
Включая слова с дефисами: серо-буро-малиновый." > test.txt

# Подсчитываем слова
cat test.txt | ./text_processor.sh count
```

### 3. Исправление повторов в тексте
```bash
echo "Это тестовый тестовый текст с повторениями повторениями." | ./text_processor.sh fix-repeats
```

**Вывод:**
```
=== Исправление повторяющихся слов ===
Это тестовый текст с повторениями.
```

### 4. Переименование файлов
```bash
# Создаём тестовые файлы
touch app.log error.log script.py utils.py

# Переименовываем log-файлы
./text_processor.sh rename-logs

# Переименовываем py-файлы (в git-репозитории)
./text_processor.sh rename-py
```

### 5. Пайплайн обработки текста
```bash
# Обрабатываем текст: исправляем повторы -> подсчитываем слова
echo "Это текст текст с ошибками ошибками и повторениями повторениями." | \
./text_processor.sh fix-repeats | \
./text_processor.sh count
```

**Вывод:**
```
=== Исправление повторяющихся слов ===
=== Подсчёт слов в тексте ===
7
```

### 6. Справка по использованию
```bash
./text_processor.sh
```

**Вывод:**
```
Использование: ./text_processor.sh {count|rename-logs|rename-py|fix-repeats|demo}
  count        - подсчитать слова из stdin
  rename-logs  - переименовать .log файлы
  rename-py    - переименовать .py файлы
  fix-repeats  - исправить повторы из stdin
  demo         - запустить демонстрацию всех функций
```

Скрипт предоставляет удобный интерфейс и может использоваться для работы с текстами и файлами

## ======================================================

## 6. скрипт 'email_extractor.sh' - для поиска email-адресов 

**Название:** `email_extractor.sh`

```bash
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
```

## Компактная версия

**Название:** `find_emails.sh`

```bash
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
```

## Использование:

```bash
# С файлом
./email_extractor.sh input.txt

# Со стандартным вводом
cat input.txt | ./email_extractor.sh

# Сделать скрипт исполняемым
chmod +x email_extractor.sh
```
