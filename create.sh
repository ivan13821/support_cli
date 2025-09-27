#!/bin/bash
source /usr/local/bin/support_cli/file_modules.sh
source /usr/local/bin/support_cli/subres.sh

network_name="support_network"
subnet_name="support_subnet"
cond_file="/usr/local/bin/support_cli/.condition"




create_instance() {


    local id_subnet=$(get_subnet_id)

    echo "ВМ создается" >&2

    local response=$(yc compute instance create \
        --name "sup-vm-$RANDOM" \
        --zone ru-central1-a \
        --network-interface "subnet-id=$id_subnet,nat-ip-version=ipv4" \
        --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2204-lts,auto-delete=true \
        --memory 4GB \
        --cores 2 \
        --core-fraction 20 \
        --preemptible \
        --ssh-key ~/.ssh/support_cli_key.pub)
        
    
    
    
    local id=$(get_id "$response")
    

    echo "instance $id" >> "$cond_file"
    echo "Создана ВМ $id" >&2
}

