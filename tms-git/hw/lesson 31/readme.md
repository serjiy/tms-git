# Лабораторная работа: Настройка агента Jenkins в Docker на Windows 11

**Выполненные задачи**

## 1. Установка и настройка агента Jenkins

- Стенд реализован полностью в **Docker Desktop** на Windows 11.
- Контроллер: образ `jenkins/jenkins:lts-jdk21`.
- Агент: кастомный образ `my-jenkins-maven-agent:latest`, собранный на базе `jenkins/inbound-agent:latest-jdk21` + установлен Maven 3.9.12.
- Подключение: Inbound JNLP по WebSocket с уникальным secret (64 символа, генерируется в настройках node Jenkins).
- Основные файлы:
  - `docker-compose.yml` — оркестрация;
  - `Dockerfile.agent` — сборка агента с Maven.

## 2. Создание и настройка Pipeline

- Создан пайплайн типа **Pipeline** с именем `Test-Agent-Pipeline`.
- Использован **Declarative Pipeline**.
- Агент указан через `agent { label 'docker-agent' }`.
- Пайплайн выполняется исключительно на кастомном Docker‑агенте (не на built‑in node).

## 3. Шаги пайплайна

- **Checkout**: скачивание кода из публичного репозитория:

  ```groovy
  git url: 'https://github.com/jenkins-docs/simple-java-maven-app.git', branch: 'master'
  ```

- **Build**: компиляция и упаковка JAR:

  ```groovy
  sh 'mvn clean package'
  ```

- **Test**: запуск unit‑тестов (JUnit 5):

  ```groovy
  sh 'mvn test'
  ```

- Результат: сборка успешна, JAR создан, тесты пройдены (2 passed).

## 4. Отчётность и артефакты

- Архивация собранного JAR:

  ```groovy
  archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
  ```

- Отчёт о тестах (JUnit):

  ```groovy
  junit 'target/surefire-reports/*.xml'
  ```

- В интерфейсе билда отображаются:
  - **Test Result** — 2 passed теста;
  - **Build Artifacts** — JAR‑файл (`my-app-1.0-SNAPSHOT.jar`).

## 5. Безопасность агента

- Подключение по JNLP с секретным ключом (генерируется в UI Jenkins).
- Включён WebSocket (`JENKINS_WEB_SOCKET=true`) — более безопасный и стабильный канал.
- Агент работает от пользователя `jenkins` (не root).
- (Дополнительно: возможен переход на SSH с ключами.)

## 6. Гибридные окружения (дополнительно)

- Контроллер и агент — в отдельных контейнерах (распределённая среда).
- Возможность добавить второй агент (например, на базе `jenkins/inbound-agent:alpine-jdk21`) с другой меткой.
- Сборка привязана к label агента — легко переключать между разными окружениями.

**Структура стенда**

- `docker-compose.yml` — запускает контроллер и агента.
- `Dockerfile.agent` — добавляет Maven в JNLP‑агент.
- Jenkins UI доступен по `http://localhost:8080`.
- Данные сохраняются в volume (`jenkins_home`, `agent_workspace`).

**Jenkinsfile (полный код пайплайна)**

```groovy
pipeline {
    agent { label 'docker-agent' }

    stages {
        stage('Checkout') {
            steps {
                echo "Скачиваем код из GitHub..."
                git url: 'https://github.com/jenkins-docs/simple-java-maven-app.git',
                    branch: 'master'
            }
        }

        stage('Build') {
            steps {
                echo "Сборка проекта..."
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                echo "Запуск тестов..."
                sh 'mvn test'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
            junit 'target/surefire-reports/*.xml'
        }
    }
}
```