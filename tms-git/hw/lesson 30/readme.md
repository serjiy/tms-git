# Домашнее задание № 30 — Jenkins Pipeline

## Описание

Для выполнения задания был установлен **Jenkins** на Windows через **Docker Desktop**.

Использована связка из:
- основного контейнера `jenkins/jenkins:lts-jdk17`;
- `docker‑in‑docker` (для поддержки Docker‑команд).

**Особенности:**  
На Windows возникли небольшие сложности с совместимостью `bat`/ `sh`-скриптов.

Создано **два пайплайна**:
- **Declarative** — для демонстрации базовых этапов, параметров, условий и обработки ошибок;
- **Scripted** (Groovy) — для симуляции автоматизации сборки и развёртывания веб‑приложения с Docker.

**Репозиторий:**  
https://github.com/serjiy/tms-git (ветка `main`).

---

## Установка Jenkins

### Команды запуска (PowerShell)

1. **Создание сети:**  
   ```powershell
   docker network create jenkins
   ```

2. **Запуск docker‑in‑docker:**  
   ```powershell
   docker run --name jenkins-docker --rm --detach --privileged --network jenkins --network-alias docker --volume jenkins-data:/var/jenkins_home --publish 2375:2375 docker:dind
   ```

3. **Запуск Jenkins:**  
   ```powershell
   docker run --name jenkins --rm --detach --network jenkins --env DOCKER_HOST=tcp://docker:2375 --publish 8080:8080 --publish 50000:50000 --volume jenkins-packed:/var/jenkins_home jenkins/jenkins:lts-jdk17
   ```

**После запуска** Jenkins доступен по адресу:  
`http://localhost:8080`

---

## Declarative Pipeline (HW30‑Demo‑Pipeline)

Пайплайн:
- клонирует репозиторий;
- выводит структуру папки `hw`;
- опционально проверяет синтаксис Python‑файлов в указанном уроке;
- выполняет условный `echo` на ветке `main`.

**Параметры:**
- `LESSON_NUMBER` — номер урока для проверки (например, `13`, `28` и т. д.);
- `CHECK_PYTHON_SYNTAX` — флаг запуска проверки синтаксиса Python (требует `python` в агенте).

**Обработка ошибок** реализована через блок `post`.

### Код declarative пайплайна

```groovy
pipeline {
    agent any
    parameters {
        string(
            name: 'LESSON_NUMBER',
            defaultValue: '13',
            description: 'Номер урока для проверки (например, 13, 28 и т.д.)'
        )
        booleanParam(
            name: 'CHECK_PYTHON_SYNTAX',
            defaultValue: false,
            description: 'Запускать проверку синтаксиса Python? (требует python в агенте)'
        )
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/serjiy/tms-git.git'
            }
        }
        stage('Show Structure') {
            steps {
                sh 'ls -laR tms-git/hw'
                echo "Репозиторий склонирован. Папка hw содержит ~20 уроков (Lesson 13, lesson 28 и т.д.)."
            }
        }
        stage('Check Python Syntax') {
            when {
                expression { params.CHECK_PYTHON_SYNTAX == true }
            }
            steps {
                script {
                    def lessonFolder = "lesson ${params.LESSON_NUMBER.toLowerCase()}"
                    def lessonPath = "tms-git/hw/${lessonFolder}"
                    if (fileExists(lessonPath)) {
                        echo "Проверяем синтаксис в ${lessonPath}"
                        sh """
                            cd "${lessonPath}"
                            python3 -m py_compile *.py 2>&1 || echo 'Python не найден или ошибки в файлах — но этап не падает'
                        """
                    } else {
                        echo "Папка ${lessonFolder} не найдена (проверь номер урока и регистр: lesson 13 vs Lesson 13)"
                    }
                }
            }
        }
        stage('Conditional Echo (only on main)') {
            when {
                branch 'main'
            }
            steps {
                echo "Этот этап выполняется ТОЛЬКО на ветке main"
                script {
                    echo "Текущий номер урока: ${params.LESSON_NUMBER}"
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline завершён (успешно или с ошибкой)'
        }
        success {
            echo 'Всё прошло отлично!'
        }
        failure {
            echo 'Есть ошибка — смотри логи выше (вероятно bat в Linux-агенте)'
        }
    }
}
```

---

## Scripted Pipeline с Docker (HW30‑Docker‑Deploy)

Пайплайн написан в **scripted‑стиле** (`node` + Groovy) и имитирует полный цикл **CI/CD** для простого веб‑приложения:
- клонирование репозитория;
- симуляция сборки;
- симуляция создания Docker‑образа;
- развёртывание контейнера с удалением предыдущей версии;
- проверка доступности приложения.

**Особенности:**
- Реальные команды `docker` заменены на `echo` (в образе Jenkins нет установленного Docker‑клиента).
- Логика полностью сохранена.
- Ошибки обрабатываются через `try‑catch` + `finally`.

### Код scripted пайплайна

```groovy
node {
    try {
        stage('Clone repository') {
            git branch: 'main', url: 'https://github.com/serjiy/tms-git.git'
        }
        stage('Build application') {
            sh 'echo "Симуляция сборки приложения (Maven/Gradle отсутствует в репо)"'
            sh 'ls -la tms-git/hw || echo "Папка hw не найдена"'
        }
        stage('Create Docker image') {
            sh '''
                echo "Симуляция создания Docker-образа:"
                echo "Предполагаемый Dockerfile в tms-git/hw/myapp:"
                echo "FROM python:3.11-slim"
                echo "COPY . /app"
                echo "WORKDIR /app"
                echo "CMD [\"python\", \"app.py\"]"
                echo "docker build -t my-web-app:latest tms-git/hw/myapp"
            '''
        }
        stage('Deploy Docker container') {
            sh '''
                echo "Удаление предыдущей версии контейнера (доп. задание):"
                echo "docker stop my-web-app-container || true"
                echo "docker rm my-web-app-container || true"
                echo "docker rmi my-web-app:previous || true"
                echo "Запуск новой версии:"
                echo "docker run -d -p 8080:80 --name my-web-app-container nginx:latest"
                echo "(в реальности заменить nginx на свой образ)"
            '''
        }
        stage('Check application') {
            sh '''
                echo "Симуляция проверки доступности:"
                echo "sleep 5"
                echo "curl -f http://localhost:8080 || echo 'Приложение не отвечает'"
                echo "Результат: Приложение доступно (симуляция успеха)"
            '''
        }
    } catch (Exception e) {
        echo "Ошибка во время выполнения: ${e.message}"
        currentBuild.result = 'FAILURE'
    } finally {
        echo 'Groovy-скрипт завершён'
        sh 'echo "Очистка (симуляция): docker stop/rm my-web-app-container"'
    }
}
```

---

## Скриншоты результатов Build

- **HW30‑Docker‑Deploy**  
- **HW30‑Demo‑Pipeline** (проверка урока № 28 с файлом `*.py`)  
