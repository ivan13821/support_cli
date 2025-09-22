#!/bin/bash
source /usr/local/bin/support_cli/create.sh
source /usr/local/bin/support_cli/drop.sh

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
}




#Функция создает ресурс
create() {
    local has_flags=false

    while [ $# -gt 0 ]; do
        case "$1" in
            -v|--vm)
                create_vm
                has_flags=true
                ;;
            -p|--postgresql)
                echo "postgresql"
                has_flags=true
                ;;
            -c|--clickhouse)
                echo "clickhouse"
                has_flags=true
                ;;
            --help)
                echo "help"
                has_flags=true
                ;;
            *)
                echo "Неизвестная опция: $1"
                has_flags=true
                return 1
                ;;
        esac
        shift  
    done
    
    if [[ "$has_flags" == false ]]; then
        echo "Не было передано ни одного флага"
        echo "Для более подробной информации введите --help"
    fi
}




#Вывод, если введен неверный аргумент
unknow_command() {
    echo "К сожалению я не знаю такой команды. Убедитесь в правильности ее написания или введите --help"
}


#------- создание ресурсов






main "$@"