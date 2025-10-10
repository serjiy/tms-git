#!/bin/bash
# Добавление хэша коммита ко всем .py файлам
for f in *.py; do 
    mv "$f" "${f%.py}_$(git rev-parse --short HEAD).py"
done