# Support CLI 🚀
CLI для работы с Yandex Cloud Support

<br>

# 📖 Описание
Support CLI - это инструмент командной строки, который помогает автоматизировать задачи развертывания инфраструктуры в Yandex Cloud. Упрощает управление ресурсами и ускоряет процесс разработки.

<br>

# ⚡ Быстрый старт
## Установка
1. Скачайте файл установки

```bash
wget https://raw.githubusercontent.com/ivan13821/support_cli/main/init.sh
```
## Запустите установку

```bash
sudo bash init.sh
```

# 🛠 Возможности
- ✅ Автоматическое развертывание инфраструктуры

- 🔧 Управление ресурсами Yandex Cloud

- ⚡ Бысрое удаление созданных ресурсов

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
Сделано с ❤️ для Yandex Cloud

<div align="center">
⭐ Не забудьте поставить звезду репозиторию, если проект вам помог!