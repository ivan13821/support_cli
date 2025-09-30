





get_id() {
    local response="$1" 
    echo "$response" | awk '$1 == "id:" {print $2}'
}



get_network_id_for_route_table() {
    local id="$1"
    local response="$(yc vpc route-table get $id)" 
    echo "$response" | awk '$1 == "network_id:" {print $2}'
}



states_has() {
    local resource="$1" 
    local cond_file="$2"
    if grep -q "^${resource} " "$cond_file"; then
        return 0  # true - ресурс найден
    else
        return 1  # false - ресурс не найден
    fi
}



get_resource_on_id() {
    #Возвращает id ресурса 

    local resource="$1" 
    local cond_file="$2"

    awk -v resource="$resource" '$1 == resource {print $2; exit}' "$cond_file"
}



get_ip() {
    #Возвращает ip адрес по идентификатору

    local id="$1"
    local response="$(yc compute instance get $id)"
    echo "$response" | awk '/primary_v4_address:/ {found=1} found && /address:/ {if(!ip) {ip=$2}} END {print ip}'
}