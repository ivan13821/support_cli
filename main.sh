#!/bin/bash
USER_HOME="~"
PROJECT_DIR="$USER_HOME/support_cli"

source "$PROJECT_DIR/create/main.sh"
source "$PROJECT_DIR/drop.sh"

#Этот скрипт позволяет создавать и удалять различные ресурсы Yandex Cloud.
#Это нужно для саппортов, чтобы облегчить им жизнь

#основная функция, обрабатывает первый аргумент
main() {

    #Провяет наличие первого аргумента
    if [ -z "$1" ] 
    then
        echo "Ошибка: Первый аргумент не может быть пустым"
        return 0
    fi

    local command="$1"
    shift  # Убираем первый аргумент (create/drop)

    if [ "$command" == "create" ] 
    then 
        create "$@"
    elif [ "$command" == "drop" ]
    then
        #функция удаляет все, что было создано по ходу использования прогаммы 
        drop
    else
        unknow_command
    fi

    #очистка кэша
    > "$PROJECT_DIR/.states"
}

#Вывод, если введен неверный аргумент
unknow_command() {
    echo "К сожалению я не знаю такой команды. Убедитесь в правильности ее написания или введите --help"
}

#Запуск функции
main "$@"