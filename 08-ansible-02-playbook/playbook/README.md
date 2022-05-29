# 08-ansible-02-playbook 

## Что делает playbook?

Плейбук разворачивает на хосте под управлением CentOS два приложения:
1. ClickHouse
2. Vector

Дистрибутивы ClickHouse устанавливаются с использованием пакетов `rpm`,
Vector устанавливается из архива `.tar.gz`.

Этапы установки ClickHouse:
- Скачивание дистрибутивов
- Установка скачанных пакетов
- Запуск службы
- Создание базы данных

Этапы установки Vector:
- Скачивание архива
- Создание рабочего каталога
- Распакова архива в рабочий каталог
- Указание окружения

## Параметры 

- `IP-адрес` хоста необходимо задать в файле [prod.yml](./inventory/prod.yml)
- `Верcия` ClickHouse и Vector задается в файле [vars.yml](./group_vars/clickhouse/vars.yml)
- `Рабоччий каталог` Vector устанавливается в `/opt` с правами `root`, изменть его можно в том же файле [vars.yml](./group_vars/clickhouse/vars.yml)

## Теги, используемые в плейбуке

- ClickHouse
- Vector