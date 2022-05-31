# 08-ansible-03-yandex

## Что делает playbook?

Плейбук разворачивает на трёх хостах по одному из приложений:
- ClickHouse
- Vector
- LightHouse

Дистрибутивы ClickHouse и Vector устанавливаются с использованием пакетов `rpm`,
LightHouse скачивается из репозитория на GitHub.

Этапы установки ClickHouse:
- Скачивание дистрибутивов
- Установка скачанных пакетов
- Запуск службы
- Создание базы данных

Этапы установки Vector:
- Установка дистрибутива
- Создание и валидация фала конфигурации
- Создание сервиса
- Запуск сервиса

Этапы установки LightHouse*:
- Скачивается репозиторий на GitHub
- Создается файл конфигурации

 **Предварительно устанавливаются nginx и git.*

## Параметры 

| Параметр | Соответствующий файл |
|------------- | ------------- |
| `IP-адрес` | [prod.yml](./inventory/prod.yml) |
| `Верcия ClickHouse` | [clickhouse.yml](./group_vars/clickhouse.yml) |
| `Верcия Vector` | [vector.yml](./group_vars/vector.yml) |
| `Конфигурация Vector` | [vector.yml](./group_vars/vector.yml) |
| `Каталог LightHouse` | [lighthouse.yml](./group_vars/lighthouse.yml) |
| `Пользователь nginx` | [lighthouse.yml](./group_vars/lighthouse.yml) |

## Теги, используемые в плейбуке

- clickhouse
- vector
- lighthouse
- nginx