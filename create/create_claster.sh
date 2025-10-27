#!/bin/bash
USER_HOME="$HOME"
PROJECT_DIR="$USER_HOME/support_cli"

source "$PROJECT_DIR/file_modules.sh"

cond_file="$PROJECT_DIR/.condition"

get_username() {
    #Возвращает имя пользователя для кластера
    echo "support"
}

get_database_name() {
    #Возвращает имя Базы данных
    echo "supportDataBase"
}

get_password() {
    #Возвращает набор чисел. Можно использовать как пароль

    local database_name="$1" #Название СУБД
    local password="$RANDOM$RANDOM$RANDOM"

    echo "">&2
    echo "Пароль для пользователя $(get_username) для подключения к кластеру $database_name: $password">&2
    echo "Путь к БД: $(get_database_name)">&2
    echo "">&2

    echo "$password"
}

create_postgresql() {
    #Создает кластер PostgreSQL

    echo "Создается кластер PosqtgreSQL">&2

    spinner &
    SPINNER_PID=$!

    local response=$(yc managed-postgresql cluster create \
        --name "support-$RANDOM" \
        --environment production \
        --network-id "$(get_network_id)" \
        --host zone-id=ru-central1-a,`
                `subnet-id="$(get_subnet_id)",`
                `assign-public-ip=true \
        --resource-preset b1.medium \
        --user "name=$(get_username),password=$(get_password "PosqtgreSQL")" \
        --database "name=supportDataBase,owner=$(get_username)" \
        --disk-size 10 \
        --disk-type network-ssd \
        --datalens-access \
        --websql-access \
        --serverless-access \
        --datatransfer-access \
        --yandexquery-access)
    
    local id=$(get_id "$response")

    kill $SPINNER_PID

    echo "Кластер PosqtgreSQL создан">&2

    echo "postgresql $id" >> "$cond_file"
}

create_mysql() {
    #Функция для создания кластера MySQL

    echo "Создается кластер MySQL">&2

    spinner &
    SPINNER_PID=$!

    local response=$(yc managed-mysql cluster create \
        --name "support-$RANDOM" \
        --environment production \
        --network-id "$(get_network_id)" \
        --host zone-id=ru-central1-a,`
            `subnet-id="$(get_subnet_id)",`
            `assign-public-ip=true,`
            `priority=0,`
            `backup-priority=0 \
        --mysql-version 8.0 \
        --resource-preset b1.medium \
        --user "name=$(get_username),password=$(get_password 'MySQL')" \
        --database "name=$(get_database_name)" \
        --disk-size 10 \
        --disk-type network-ssd \
        --datalens-access \
        --websql-access \
        --datatransfer-access \
        --yandexquery-access)
    
    local id=$(get_id "$response")

    kill $SPINNER_PID

    echo "Кластер MySQL создан">&2

    echo "mysql $id" >> "$cond_file"
}

create_clickhouse() {
    #Создает кластер ClickHouse

    echo "Создается кластер ClickHouse">&2

    spinner &
    SPINNER_PID=$!

    local response=$(yc managed-clickhouse cluster create \
        --name "support-$RANDOM" \
        --environment production \
        --network-id "$(get_network_id)" \
        --host type=clickhouse,`
            `zone-id=ru-central1-a,`
            `subnet-id="$(get_subnet_id)",`
            `assign-public-ip=true \
        --clickhouse-resource-preset b1.medium \
        --clickhouse-disk-type network-ssd \
        --clickhouse-disk-size 10 \
        --user "name=$(get_username),password=$(get_password 'ClickHouse')" \
        --database "name=$(get_database_name)" \
        --websql-access=true \
        --datalens-access \
        --websql-access \
        --serverless-access \
        --datatransfer-access \
        --yandexquery-access)
    
    local id=$(get_id "$response")

    kill $SPINNER_PID

    echo "Кластер ClickHouse создан">&2

    echo "clickhouse $id" >> "$cond_file"
}