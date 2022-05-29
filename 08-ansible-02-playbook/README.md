# 08.02 Работа с Playbook — Алексей Храпов

## Подготовка к выполнению

> 1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.

Использован [старый репозиторий](https://github.com/AlexeyKhrapov/ansible-homeworks).

> 2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

```bash
kad@g-deb-test:~/studing/ansible/ansible-homeworks/08-ansible-02-playbook/playbook$ ls -l 
итого 12
drwxr-xr-x 3 kad kad 4096 мая 29 16:54 group_vars
drwxr-xr-x 2 kad kad 4096 мая 29 16:54 inventory
-rw-r--r-- 1 kad kad 1363 мая 29 16:54 site.yml
```

> 3. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

Хост подготовлен.

## Основная часть

> 1. Приготовьте свой собственный inventory файл `prod.yml`.

```bash
kad@g-deb-test:~/studing/ansible/ansible-homeworks/08-ansible-02-playbook/playbook$ cat ./inventory/prod.yml 
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 172.20.0.2
      ansible_connection: ssh
      ansible_user: app-admin
      ansible_ssh_private_key_file: files/id_rsa_ansible
```

> 2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
> 3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
> 4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

```yaml
- name: Vector Install
  hosts: clickhouse
  tasks:
    - name: Vector Download
      ansible.builtin.get_url:
        url: "{{ vector_url }}"
        dest: "/tmp/vector-{{ vector_version }}-x86_64-unknown-linux-gnu.tar.gz"
        mode: 0644
        timeout: 60
        force: true
        validate_certs: false
      register: get_vector
      until: get_vector is succeeded
      tags: Vector
    - name: Vector directory create
      become: true
      file:
        path: "{{ vector_dir: }}"
        state: directory
        mode: 0755
      tags: Vector
    - name: Vector Extraction
      become: true
      unarchive:
        copy: false
        src: "/tmp/vector-{{ vector_version }}-x86_64-unknown-linux-gnu.tar.gz"
        dest: "{{ vector_dir: }}"
        extra_opts: [--strip-components=2]
        creates: "{{ vector_home_dir: }}/bin/vector"
      tags: Vector
    - name: Vector Set Enviroment
      become: true
      template:
        src: files/vector.sh.j2
        dest: /etc/profile.d/vector.sh
        mode: 0755
      tags: Vector
```

> 5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
kad@g-deb-test:~/studing/ansible/ansible-homeworks/08-ansible-02-playbook/playbook$ ansible-lint site.yml
WARNING: PATH altered to include /usr/bin
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```

> 6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```bash
kad@g-deb-test:~/studing/ansible/ansible-homeworks/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-client-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-client-22.3.3.44.rpm' found on system"]}

PLAY RECAP *****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0 
```
Результат предсказуемый, т.к. пакетов на самом деле ещё нет.
Однако, playbook отрабатывает нормально:
```bash
kad@g-deb-test:~/studing/ansible/ansible-homeworks/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Flush handlers] ******************************************************************************************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] *********************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] *****************************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Vector Install] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Vector Download] *****************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Vector directory create] *********************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Vector Extraction] ***************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Vector Set Enviroment] ***********************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY RECAP *****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=1    changed=9    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
```


> 7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```bash
kad@g-deb-test:~/studing/ansible/ansible-homeworks/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 500, "group": "app-admin", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "app-admin", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 500, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ******************************************************************************************************************************************************************************************

TASK [Create database] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Vector Install] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Vector Download] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Vector directory create] *********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Vector Extraction] ***************************************************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Vector Set Enviroment] ***********************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP *****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0
```

> 8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
kad@g-deb-test:~/studing/ansible/ansible-homeworks/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 500, "group": "app-admin", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "app-admin", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 500, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ******************************************************************************************************************************************************************************************

TASK [Create database] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Vector Install] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Vector Download] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Vector directory create] *********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Vector Extraction] ***************************************************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Vector Set Enviroment] ***********************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP *****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=8    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0
```

> 9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

[Файл](./playbook/README.md) подготовлен.

> 10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

Выполнено.