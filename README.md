# Support CLI 🚀
CLI для работы с Yandex Cloud Support

# 📖 Описание
Support CLI - это инструмент командной строки, который помогает автоматизировать задачи развертывания инфраструктуры в Yandex Cloud. Упрощает управление ресурсами и ускоряет процесс разработки.

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

# 👥 Авторы
**ivashka138**

Сделано с ❤️ для Yandex Cloud

<div align="center">
⭐ Не забудьте поставить звезду репозиторию, если проект вам помог!