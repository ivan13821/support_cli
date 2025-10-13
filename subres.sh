#!/bin/bash
source USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/file_modules.sh





get_network_id () {

    if ! states_has "vpn" "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.states"; then 
        network_id=$(create_network)
    fi

    echo "$(get_resource_on_id "vpn" "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.states")"
}




get_subnet_id () {

    if ! states_has "subnet" "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.states"; then 
        subnet_id=$(create_subnet)
    fi

    echo "$(get_resource_on_id "subnet" "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.states")"
}




#Не вызывать отдельно!!!
create_network () {
    #Создает сети и подсеть 

    echo "Сеть создается" >&2

    #создание сети
    local response=$(yc vpc network create --name "support_network-$RANDOM")
    local id=$(get_id "$response")
    
    echo "vpn $id" >> "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.condition"
    echo "vpn $id" >> "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.states"

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

    echo "subnet $id" >> "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.condition"
    echo "subnet $id" >> "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.states"

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

    echo "route_table $id" >> "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.condition"
    echo "route_table $id" >> "USER_HOME=$(eval echo ~$SUDO_USER)/support_cli/.states"
}