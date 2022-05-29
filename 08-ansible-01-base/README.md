# 08.01 Введение в Ansible — Алексей Храпов

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.

```bash
kad@g-deb-test:~/studing/ansible$ ansible --version
ansible [core 2.12.5]
  config file = None
  configured module search path = ['/home/kad/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.9/dist-packages/ansible
  ansible collection location = /home/kad/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110]
  jinja version = 2.11.3
  libyaml = True
```

2. Создайте свой собственный публичный репозиторий на github с произвольным именем.

https://github.com/AlexeyKhrapov/ansible-homeworks

3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

```bash
kad@g-deb-test:~/studing/ansible$ ls -l ./playbook/
итого 16
drwxr-xr-x 5 kad kad 4096 мая 28 22:07 group_vars
drwxr-xr-x 2 kad kad 4096 мая 28 22:07 inventory 
-rw-r--r-- 1 kad kad 1293 мая 18 23:36 README.md 
-rw-r--r-- 1 kad kad  209 мая 18 23:36 site.yml
```

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ***********************************************************************************************************************************************************************************************
*ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ cat ./group_vars/all/examp.yml 
---
  some_fact: all default fact
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ docker ps
CONTAINER ID   IMAGE               COMMAND            CREATED          STATUS          PORTS     NAMES
60e23f42a128   pycontribs/ubuntu   "sleep infinity"   52 seconds ago   Up 50 seconds             ubuntu
61b081228dbf   centos:7            "sleep infinity"   6 minutes ago    Up 50 seconds             centos7
```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ cat ./group_vars/{deb,el}/*
---
  some_fact: "deb default fact"
---
  some_fact: "el default fact"
```

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-vault encrypt ./group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
kad@g-deb-test:~/studing/ansible/playbook$ ansible-vault encrypt ./group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
kad@g-deb-test:~/studing/ansible/playbook$ cat ./group_vars/{deb,el}/*
$ANSIBLE_VAULT;1.1;AES256
37353333643534656539613232396461613065343066346138373966663034346366393638326135
6364383034663262386330343935313666396463636636360a356135303739343333396462636339
33333765356565316265656466633730613463633264313138643334656135626232643535363433
6432343637353634340a353432343766353131376561616231353531373532373037343936653238
33643061353238613763366136353339646536623632623635373439613565353139613237326437
3964663763653563313661386264616334623961646238663765
$ANSIBLE_VAULT;1.1;AES256
62646437346533383266316634656132393865373561653836653261636565646132393739623565
3837643163376634373363396136656262356265353564660a613538663762383665316235633664
63306634643762653838323961383135646438643033386330366664333033366366363738373062
6465313335306366660a303062623565323533633462376464303163393832383830373631326534
66383532626230653538623765303436356466663236653565303764396466343234373539373266
3230336533376539663436663338303332343735316230343138
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

9.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-doc -l -t connection
...
local                          execute on controller
...
(END)
```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ cat ./inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

https://github.com/AlexeyKhrapov/ansible-homeworks

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-vault decrypt ./group_vars/deb/examp.yml 
Vault password: 
Decryption successful
kad@g-deb-test:~/studing/ansible/playbook$ ansible-vault decrypt ./group_vars/el/examp.yml
Vault password: 
Decryption successful
kad@g-deb-test:~/studing/ansible/playbook$ cat ./group_vars/{deb,el}/*
---
  some_fact: "deb default fact"
---
  some_fact: "el default fact"
```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-vault encrypt_string PaSSw0rd
New Vault password: 
Confirm New Vault password: 
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          35303766346364316465663330353033333838663935373465623962303439323062326530366564
          3265343532303332313630396539643663396630343033620a343963303338356566343638363463
          62396461623766346230623833313737623835656237373564376333666564343765613837626339
          3661396361383331620a326565383564353966363238353430303730373335303661646237626635
          3364
Encryption successful
```
```bash
kad@g-deb-test:~/studing/ansible/playbook$ cat ./group_vars/all/examp.yml 
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          35303766346364316465663330353033333838663935373465623962303439323062326530366564
          3265343532303332313630396539643663396630343033620a343963303338356566343638363463
          62396461623766346230623833313737623835656237373564376333666564343765613837626339
          3661396361383331620a326565383564353966363238353430303730373335303661646237626635
          3364
```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
   
```bash
kad@g-deb-test:~/studing/ansible/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

```bash
kad@g-deb-test:~/studing/ansible/playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
  fedora:
    hosts:
      fedora:
        ansible_connection: docker
kad@g-deb-test:~/studing/ansible/playbook$ cat site.yml 
---
  - name: Print os facts
    hosts: all
    tasks:
      - name: Print OS
        debug:
          msg: "{{ ansible_distribution }}"
      - name: Print fact
        debug:
          msg: "{{ some_fact }}"
      - name: Print custom variable
        debug:
          msg: "{{ custom_var }}"
        when:
          - ansible_distribution == "Fedora"
kad@g-deb-test:~/studing/ansible/playbook$ cat group_vars/fedora/examp.yml 
---
  custom_var: "I am a custom variable for Fedora"
kad@g-deb-test:~/studing/ansible/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
word:Vault password: 
[WARNING]: Found both group and host with same name: fedora

PLAY [Print os facts] ******************************************************************************************************************************************************************************************
TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] **********************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "PaSSw0rd"
}

TASK [Print custom variable] ***********************************************************************************************************************************************************************************
skipping: [centos7]
skipping: [ubuntu]
skipping: [localhost]
ok: [fedora] => {
    "msg": "I am a custom variable for Fedora"
}

PLAY RECAP *****************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
fedora                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

```bash
#!/usr/local/env bash
docker-compose up -d
ansible-playbook site.yml -i inventory/prod.yml --vault-password-file pass
docker-compose down
```

6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

https://github.com/AlexeyKhrapov/ansible-homeworks