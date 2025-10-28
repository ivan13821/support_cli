#!/bin/bash -i

sudo apt install yq

USER_HOME="$HOME"  
PROJECT_DIR="$USER_HOME/support_cli"

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

run_command "chmod +x $USER_HOME/support_cli/main.sh" "Настраиваю исполняемый файл"

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