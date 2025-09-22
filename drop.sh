#!/bin/bash




drop() {
    # Временный файл для хранения сетей (удаляем после подсетей)
    local temp_network_file=$(mktemp)
    
    while IFS=' ' read -r resource id; do
        case $resource in
            "subnet")
                drop_subnet "$id"
                ;;
            "vpn"|"network")  # Добавил network на случай опечатки
                echo "network $id" >> "$temp_network_file"
                ;;
        esac
    done < .condition
    
    # Удаляем сети после подсетей
    if [[ -f "$temp_network_file" ]]; then
        while IFS=' ' read -r resource id; do
            drop_network "$id"
        done < "$temp_network_file"
        rm -f "$temp_network_file"
    fi
    
    # Очищаем файл .condition
    > .condition  # Правильный способ очистки файла
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