#!/bin/bash
# Добавление timestamp ко всем .log файлам (filename_timestamp.log)
for f in *.log; do 
    mv "$f" "${f%.log}_$(date +%Y%m%d_%H%M%S).log"
done