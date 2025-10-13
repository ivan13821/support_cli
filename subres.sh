#!/bin/bash
USER_HOME=$(eval echo ~$SUDO_USER)
PROJECT_DIR="$USER_HOME/support_cli"

source "$PROJECT_DIR/file_modules.sh"

get_network_id () {
    if ! states_has "vpn" "$PROJECT_DIR/.states"; then 
        network_id=$(create_network)
    fi

    echo "$(get_resource_on_id "vpn" "$PROJECT_DIR/.states")"
}

get_subnet_id () {
    if ! states_has "subnet" "$PROJECT_DIR/.states"; then 
        subnet_id=$(create_subnet)
    fi

    echo "$(get_resource_on_id "subnet" "$PROJECT_DIR/.states")"
}

#Не вызывать отдельно!!!
create_network () {
    #Создает сети и подсеть 

    echo "Сеть создается" >&2

    #создание сети
    local response=$(yc vpc network create --name "support_network-$RANDOM")
    local id=$(get_id "$response")
    
    echo "vpn $id" >> "$PROJECT_DIR/.condition"
    echo "vpn $id" >> "$PROJECT_DIR/.states"

    echo "Создана сеть $id" >&2
}

#Не вызывать отдельно!!!
create_subnet () {
    echo "Подсеть создается" >&2

    local response=$(yc vpc subnet create \
                        --name "support_subnet-$RANDOM" \
                        --zone ru-central1-a\
                        --network-id "$(get_network_id)"\
                        --range 192.168.0.0/24)
    local id=$(get_id "$response")

    echo "subnet $id" >> "$PROJECT_DIR/.condition"
    echo "subnet $id" >> "$PROJECT_DIR/.states"

    echo "Создана подсеть $id" >&2
}

create_route_table() {
    #Создает таблицу маршрутизации и привязывает ее к нужному ip

    local ip="$1"

    echo "Создается таблица маршрутизации" >&2

    local response=$(yc vpc route-table create \
        --name="support-$RANDOM" \
        --network-id="$(get_network_id)" \
        --route destination=0.0.0.0/0,next-hop="$ip")
    
    local id=$(get_id "$response")

    echo "Создана таблица маршрутизации $id" >&2

    echo "Таблица маршрутизации привязывается к сети" >&2

    local trash=$(yc vpc subnet update $(get_subnet_id) \
        --route-table-id "$id")

    echo "Таблица маршрутизации успешно привязана" >&2

    echo "route_table $id" >> "$PROJECT_DIR/.condition"
    echo "route_table $id" >> "$PROJECT_DIR/.states"
}