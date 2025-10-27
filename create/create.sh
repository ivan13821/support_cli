#!/bin/bash
USER_HOME="~"
PROJECT_DIR="$USER_HOME/support_cli"

source "$PROJECT_DIR/file_modules.sh"
source "$PROJECT_DIR/subres.sh"

network_name="support_network"
subnet_name="support_subnet"
cond_file="$PROJECT_DIR/.condition"

create_instance() {
    #Создает ВМ в зависимости от переданного образа

    family="$1"

    local id_subnet=$(get_subnet_id)

    echo "ВМ создается" >&2

    local response=$(yc compute instance create \
        --name "sup-vm-$RANDOM" \
        --zone ru-central1-a \
        --network-interface "subnet-id=$id_subnet,nat-ip-version=ipv4" \
        --create-boot-disk "image-folder-id=standard-images,image-family=$family,auto-delete=true" \
        --memory 4GB \
        --cores 2 \
        --core-fraction 20 \
        --preemptible \
        --ssh-key $USER_HOME/.ssh/support_cli_key.pub)
        
    echo "Создана ВМ $id" >&2
    
    
    local id=$(get_id "$response")
    local ip=$(get_ip "$id")

    if [[ $family == "nat-instance-ubuntu" ]]; then
        create_route_table "$ip"
    fi
    

    echo "instance $id" >> "$cond_file"
    

    echo ""
    echo "Для подключения к ВМ используйте команду:"
    echo "ssh -i $USER_HOME/.ssh/support_cli_key yc-user@<ip>"
    echo ""
}

create_bucket() {
    #Создает бакет
    
    echo "Создается бакет"
    yc storage bucket create --name "support-$RANDOM"
    echo "Бакет создан"
}