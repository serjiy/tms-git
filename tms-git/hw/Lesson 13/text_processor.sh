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