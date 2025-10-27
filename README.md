# Support CLI 🚀
CLI для работы с Yandex Cloud Support

<br>

# 📖 Описание
Support CLI - это инструмент командной строки, который помогает автоматизировать задачи развертывания инфраструктуры в Yandex Cloud. Упрощает управление ресурсами и ускоряет процесс разработки.

<br>

# ⚡ Начало работы
## Bажно‼️
Для корректной работы этой программы нужна YC CLI с правами на все создаваемые ресурсы.  
Скачать и настроить ее можно по <a href="https://yandex.cloud/ru/docs/cli/quickstart#install">инструкции</a>

## Установка
1. Скачайте проект в корневую папку пользователя

```bash
cd ~/
git clone https://github.com/ivan13821/support_cli
```
2. Зайдите в файл ~/.bashrc

```bash
nano ~/.bashrc
```

3. Создайте алиас
```bash
#my-app for supports
angel() {
    local script_path="/<Путь до корневой директории пользователя>/support_cli/main.sh"
    
    if [[ ! -f "$script_path" ]]; then
        echo "Ошибка: Скрипт $script_path не найден" >&2
        return 1
    fi
    
    "$script_path" "$@"
}
```

<br>

# 🛠 Возможности
- ✅ Автоматическое развертывание инфраструктуры

- 🔧 Управление ресурсами Yandex Cloud

- ⚡ Быстрое удаление созданных ресурсов

<br>

# 🚀 Использование
## Создание ВМ
```bash
angel create --ubuntu 
```

## Создание ВМ с выходом через NAT
```bash
angel create --ubuntu --nat
```

## Создание кластеров 
```bash
angel create --postgresql --mysql --clickhouse
```

## Удаление ресурсов
```bash
angel drop
```
<br>

# 👥 Авторы
 - ivashka138
<br>
⭐ Не забудьте поставить звезду репозиторию, если проект вам помог!<br>

**Сделано с ❤️ для Yandex Cloud**