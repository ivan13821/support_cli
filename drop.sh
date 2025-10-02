#!/bin/bash
source /usr/local/bin/support_cli/file_modules.sh
source /usr/local/bin/support_cli/subres.sh

#Массив ресурсов по приоритету (макс -> мин)
resourses_prior=("route_table" "instance" "postgresql" "subnet" "vpn")



drop() {
    #Удаляет ресурсы по их приоритету
    
    for res in "${resourses_prior[@]}"; do
        
        while IFS=' ' read -r resource id; do
            
            if [[ $resource == $res ]]; then
                $res "$id"
            fi
            
        done < /usr/local/bin/support_cli/.condition
    done

    #Очистка файла
    > /usr/local/bin/support_cli/.condition 

}






vpn() {
    #Функция для удаления сети

    local id="$1"
    echo "Удаляется сеть $id"
    yc vpc network delete "$id"
    echo "Удалена сеть $id"
}


subnet() {
    #Функция для удаления подсети
    
    local id="$1"
    echo "Удаляется подсеть $id"
    yc vpc subnet delete "$id"
    echo "Удалена подсеть $id"
}


instance() {
    #Функция для удаления ВМ

    local id="$1"
    echo "Удаляется ВМ $id"
    yc compute instance delete "$id"
    echo "Удалена ВМ $id"
}


route_table() {
    #Функция для удаления таблицы маршрутизации

    local table_id="$1"
    echo "Таблица маршрутизации отвязывается"

    #Отвязываем все таблицы маршрутизации
    while IFS=' ' read -r resource id; do
            
        if [[ $resource == "subnet" ]]; then
            local trash=$(yc vpc subnet update $id --disassociate-route-table)
        fi
            
    done < /usr/local/bin/support_cli/.condition
    echo "Удаляется таблица маршрутизации $table_id"
    yc vpc route-table delete $table_id
    echo "Таблица маршрутизации удалена"
}


postgresql() {
    #Функция для удаления кластера PostgreSQL

    local id="$1"

    echo "Удаляется кластер PostgreSQL"
    yc managed-postgresql cluster delete "$id"
    echo "Кластер PosqtgreSQL удален"

}