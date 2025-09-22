#!/bin/bash


network_name="support_network"
subnet_name="support_subnet"

create_vm() {
    create_network
}



create_network() {

    #создание сети
    local response=$(yc vpc network create --name "$network_name")
    local id=$(get_id "$response")
    echo "vpn $id" >> .condition
    echo "Создана сеть $id"

    #Создание подсети
    local response=$(yc vpc subnet create \
                        --name "$subnet_name" \
                        --zone ru-central1-a\
                        --network-id "$id"\
                        --range 192.168.0.0/24)
    local id=$(get_id "$response")
    echo "subnet $id" >> .condition
    echo "Создана подсеть $id"
}



create_instance() {
    local response=$(yc vpc network create --name "$network_name")
    local id=$(get_id "$response")
    echo "instance $id" >> .condition
    echo "Создана ВМ $id"
}





get_id() {
    local response="$1" 
    echo "$response" | awk '$1 == "id:" {print $2}'
}