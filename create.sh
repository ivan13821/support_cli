#!/bin/bash
source /usr/local/bin/support_cli/file_modules.sh

network_name="support_network"
subnet_name="support_subnet"
cond_file="/usr/local/bin/support_cli/.condition"


create_network() {


    if states_has "vpn"; then 
        #echo "сеть уже создана"
        id=$(get_resource_on_id "vpn")
        create_subnet "$id"
        return 0
    fi

    echo "Сеть создается"

    #создание сети
    local response=$(yc vpc network create --name "support_network-$RANDOM")
    local id=$(get_id "$response")
    echo "vpn $id" >> "$cond_file"
    echo "Создана сеть $id"

    create_subnet "$id"
}



create_subnet () {

    network_id="$1"

    if states_has "subnet"; then 
        #echo "подсеть уже создана"
        return 0
    fi

    echo "Подсеть создается"


    local response=$(yc vpc subnet create \
                        --name "support_subnet-$RANDOM" \
                        --zone ru-central1-a\
                        --network-id "$network_id"\
                        --range 192.168.0.0/24)
    local id=$(get_id "$response")
    echo "subnet $id" >> "$cond_file"
    echo "Создана подсеть $id"
}



create_instance() {
    create_network

    subnet_id=$(get_resource_on_id "subnet")

    echo "ВМ создается"

    local response=$(yc compute instance create \
        --name "sup-vm-$RANDOM" \
        --zone ru-central1-a \
        --network-interface subnet-id=$subnet_id,nat-ip-version=ipv4 \
        --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts \
        --memory 4GB \
        --cores 2 \
        --core-fraction 20 \
        --preemptible \
        --ssh-key ~/.ssh/support_cli_key.pub)
    
    local id=$(get_id "$response")
    

    echo "instance $id" >> "$cond_file"
    echo "Создана ВМ $id"
}

