#!/bin/bash
source /usr/local/bin/support_cli/file_modules.sh
source /usr/local/bin/support_cli/subres.sh

network_name="support_network"
subnet_name="support_subnet"
cond_file="/usr/local/bin/support_cli/.condition"




create_instance() {

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
        --ssh-key ~/.ssh/support_cli_key.pub)
        
    echo "Создана ВМ $id" >&2
    
    
    local id=$(get_id "$response")
    local ip=$(get_ip "$id")

    if [[ $family == "nat-instance-ubuntu" ]]; then
        create_route_table "$ip"
    fi
    

    echo "instance $id" >> "$cond_file"
    

    echo ""
    echo "Для подключения к ВМ используйте команду:"
    echo "ssh -i ~/.ssh/support_cli_key yc-user@<ip>"
    echo ""
}




create_bucket() {
    
    echo "Создается бакет"
    yc storage bucket create --name "support-$RANDOM"
    echo "Бакет создан"

}








create_postgresql() {

    local password="$RANDOM$RANDOM$RANDOM"

    echo "">&2
    echo "Пароль для пользователя support для подключения к PostgreSQL $password" >&2
    echo "">&2

    echo "Создается кластер PosqtgreSQL"

    local response=$(yc managed-postgresql cluster create \
        --name "support-$RANDOM" \
        --environment production \
        --network-id "$(get_network_id)" \
        --host zone-id=ru-central1-a,`
                `subnet-id="$(get_subnet_id)",`
                `assign-public-ip=true \
        --resource-preset b1.medium \
        --user "name=support,password=$password" \
        --database name=supportDataBase,owner=support \
        --disk-size 10 \
        --disk-type network-ssd \
        --deletion-protection)
    
    local id=$(get_id "$response")

    echo "Кластер создан">&2

    echo "postgresql $id" >> "$cond_file"
}