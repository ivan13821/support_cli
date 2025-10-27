#!/bin/bash

USER_HOME="$HOME"
PROJECT_DIR="$USER_HOME/support_cli"

check_and_create_dir() {
    local path="$1"
    
    if [ ! -d "$path" ]; then
        mkdir -p "$path"
    fi
}

# Функция для выполнения команд с проверкой ошибок
run_command() {
    local cmd="$1"
    local description="$2"
    
    echo "$description"
    if ! eval "$cmd"; then
        echo "Ошибка: $description не удалось" >&2
        return 1
    fi
}

# Создание SSH-ключа (если не существует)
if [ ! -f "$USER_HOME/.ssh/support_cli_key" ]; then
    run_command "ssh-keygen -t rsa -b 4096 -f '$USER_HOME/.ssh/support_cli_key' -N ''" "Создаю ssh-ключ"
else
    echo "SSH-ключ уже существует, пропускаю создание"
fi

# Подготовка директории и клонирование
run_command "check_and_create_dir '$PROJECT_DIR'" "Проверяю директорию"

cd "$USER_HOME"
run_command "rm -rf support_cli" "Очищаю старую версию"
run_command "git clone https://github.com/ivan13821/support_cli support_cli" "Копирую код из репозитория"

cd support_cli
run_command "chmod +x main.sh" "Настраиваю исполняемый файл"

echo "Настраиваю алиас"

if ! grep -q "angel()" $USER_HOME/.bashrc; then
    {
        echo ""
        echo "#my-app for supports"
        echo "angel() {"
        echo "    local script_path=\"$PROJECT_DIR/main.sh\""
        echo "    "
        echo "    if [[ ! -f \"\$script_path\" ]]; then"
        echo "        echo \"Ошибка: Скрипт \$script_path не найден\" >&2"
        echo "        return 1"
        echo "    fi"
        echo "    "
        echo "    \"\$script_path\" \"\$@\""
        echo "}"
    } >> $USER_HOME/.bashrc
    echo "Алиас настроен"
else
    echo "Алиас уже настроен"
fi

source $USER_HOME/.bashrc
echo "Успешно!!!"