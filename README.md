# Support CLI 🚀
CLI для работы с Yandex Cloud Support

<br>

# 📖 Описание
Support CLI - это инструмент командной строки, который помогает автоматизировать задачи развертывания инфраструктуры в Yandex Cloud. Упрощает управление ресурсами и ускоряет процесс разработки.

<br>

# ⚡ Быстрый старт
## Bажно‼️
Для корректной работы этой программы нужна YC CLI с правами на все создаваемые ресурсы.  
Скачать и настроить ее можно по <a href="https://yandex.cloud/ru/docs/cli/quickstart#install">инструкции</a>

## Установка
1. Скачайте файл установки

```bash
wget https://raw.githubusercontent.com/ivan13821/support_cli/main/init.sh
```
2. Запустите установку

```bash
sudo bash init.sh
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
Сделано с ❤️ для Yandex Cloud