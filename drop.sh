#!/bin/bash
source /usr/local/bin/support_cli/file_modules.sh



drop() {
    # Временный файл для хранения сетей (удаляем после подсетей)
    local temp_network_file=$(mktemp)

    #-----------------------------------------
    #Обработка удаления ВМ и подсети раньше всего РЕАЛИЗОВАТЬ
    #------------------------------------------

    
    while IFS=' ' read -r resource id; do
        case $resource in
            "vpn")
                drop_network
                ;;

        esac
    done < /usr/local/bin/support_cli/.condition
    
    # Очищаем файл .condition
    > /usr/local/bin/support_cli/.condition 
}


drop_network() {
    local id="$1"
    yc vpc network delete "$id"
    echo "Удалена сеть $id"
}


drop_subnet() {
    local id="$1"
    yc vpc subnet delete "$id"
    echo "Удалена подсеть $id"
}


drop_instance() {
    local id="$1"
    yc compute instance delete "$id"
    echo "Удалена ВМ $id"
}