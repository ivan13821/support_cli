#!/bin/bash
source /usr/local/bin/support_cli/file_modules.sh





get_network_id () {

    if ! states_has "vpn" "/usr/local/bin/support_cli/.states"; then 
        network_id=$(create_network)
    fi

    echo "$(get_resource_on_id "vpn" "/usr/local/bin/support_cli/.states")"
}




get_subnet_id () {

    if ! states_has "subnet" "/usr/local/bin/support_cli/.states"; then 
        subnet_id=$(create_subnet)
    fi

    echo "$(get_resource_on_id "subnet" "/usr/local/bin/support_cli/.states")"
}




#Не вызывать отдельно!!!
create_network () {
    #Создает сети и подсеть 

    echo "Сеть создается" >&2

    #создание сети
    local response=$(yc vpc network create --name "support_network-$RANDOM")
    local id=$(get_id "$response")
    
    echo "vpn $id" >> "/usr/local/bin/support_cli/.condition"
    echo "vpn $id" >> "/usr/local/bin/support_cli/.states"

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

    echo "subnet $id" >> "/usr/local/bin/support_cli/.condition"
    echo "subnet $id" >> "/usr/local/bin/support_cli/.states"

    echo "Создана подсеть $id" >&2
}