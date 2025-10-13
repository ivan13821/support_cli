#!/bin/bash
USER_HOME=$(eval echo ~$SUDO_USER)
PROJECT_DIR="$USER_HOME/support_cli"

source "$PROJECT_DIR/create/create.sh"
source "$PROJECT_DIR/create/create_claster.sh"

#Функция создает ресурс
create() {
    local has_flags=false

    while [ $# -gt 0 ]; do
        case "$1" in
            --ubuntu)
                create_instance "ubuntu-2204-lts"
                has_flags=true
                ;;
            --debian)
                create_instance "debian-9"
                has_flags=true
                ;;
            --postgresql)
                create_postgresql
                has_flags=true
                ;;
            --clickhouse)
                create_clickhouse
                has_flags=true
                ;;
            --mysql)
                create_mysql
                has_flags=true
                ;;
            --nat)
                create_instance "nat-instance-ubuntu"
                has_flags=true
                ;;
            --bucket)
                create_bucket
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