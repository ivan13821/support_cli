#!/bin/bash
source /usr/local/bin/support_cli/file_modules.sh



drop() {
    # Временный файл для хранения сетей (удаляем после подсетей)
    local temp_network_file=$(mktemp)

    
    while IFS=' ' read -r resource id; do
        case $resource in
            "instance")
                drop_instance $(get_resource_on_id "instance")
                ;;

        esac
    done < /usr/local/bin/support_cli/.condition

    while IFS=' ' read -r resource id; do
        case $resource in
            "subnet")
                drop_subnet $(get_resource_on_id "subnet")
                ;;

        esac
    done < /usr/local/bin/support_cli/.condition





    
    while IFS=' ' read -r resource id; do
        case $resource in
            "vpn")
                drop_network $(get_resource_on_id "vpn")
                ;;

        esac
    done < /usr/local/bin/support_cli/.condition
    
    # Очищаем файл .condition
    > /usr/local/bin/support_cli/.condition 
}






drop_network() {
    local id="$1"
    echo "Удаляется сеть $id"
    yc vpc network delete "$id"
    echo "Удалена сеть $id"
}


drop_subnet() {
    local id="$1"
    echo "Удаляется подсеть $id"
    yc vpc subnet delete "$id"
    echo "Удалена подсеть $id"
}


drop_instance() {
    local id="$1"
    echo "Удаляется ВМ $id"
    yc compute instance delete "$id"
    echo "Удалена ВМ $id"
}