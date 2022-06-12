# 8.4 Работа с Roles

## Что делает [playbook](https://github.com/AlexeyKhrapov/ansible-homeworks/tree/main/08-ansible-04-role)?

Плейбук разворачивает на трёх хостах по одному из приложений:
- ClickHouse
- Vector
- LightHouse

Установка приложений происходит с использованием ролей

Роль `lighthouse` зависит от ролей `nginxinc.nginx` и `geerlingguy.git`, устанавливающих на хост с lighthouse `nginx` и `git` соответственно.

## Параметры 

Роли и их параметры описаны в соответствующих репозиториях:
- [vector-role](https://github.com/AlexeyKhrapov/vector-role)
- [lighthouse-role](https://github.com/AlexeyKhrapov/lighthouse-role)
- [clickhouse-role](https://github.com/AlexeySetevoi/ansible-clickhouse)
- [nginxinc.mginx](https://galaxy.ansible.com/nginxinc/nginx)
- [geerlingguy.git](https://galaxy.ansible.com/geerlingguy/git)
