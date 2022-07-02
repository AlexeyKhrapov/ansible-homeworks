# 08.05 Тестирование Roles 

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

## Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Ответ:

Для тестирования роль была изменена.

 - Ссылка на репозиторий: https://github.com/AlexeyKhrapov/vector-role
 - Ссылка на версию с тестированием molecule: https://github.com/AlexeyKhrapov/vector-role/releases/tag/1.1.1
 <details><summary>Вывод команды `molecule test`</summary>
 
 ```bash
kad@g-deb-test:~/studing/vector-role$ molecule test
INFO     default scenario test matrix: dependency, lint, destroy, create, converge, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/kad/studing/vector-role as project root directory
WARNING  Computed fully qualified role name of vector_role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Using /home/kad/.cache/ansible-lint/1c2e7d/roles/vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/kad/.cache/ansible-lint/1c2e7d/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
COMMAND: yamllint .
ansible-lint .

/bin/bash: строка 1: yamllint: команда не найдена
WARNING: PATH altered to include /usr/bin
WARNING  Computed fully qualified role name of vector_role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos_8)
ok: [localhost] => (item=ubuntu)
ok: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:8', 'name': 'centos_8', 'privileged': True, 'run': "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*\n"})
ok: [localhost] => (item={'command': '/sbin/init', 'dockerfile': 'Dockerfile.j2', 'env': {'DEBIAN_FRONTEND': 'noninteractive', 'TZ': 'Etc/GMT+5'}, 'image': 'ubuntu:20.04', 'name': 'ubuntu', 'privileged': True})
ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:7', 'name': 'centos_7', 'privileged': True})

TASK [Create Dockerfiles from image names] *************************************
changed: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:8', 'name': 'centos_8', 'privileged': True, 'run': "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*\n"})
changed: [localhost] => (item={'command': '/sbin/init', 'dockerfile': 'Dockerfile.j2', 'env': {'DEBIAN_FRONTEND': 'noninteractive', 'TZ': 'Etc/GMT+5'}, 'image': 'ubuntu:20.04', 'name': 'ubuntu', 'privileged': True})
changed: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:7', 'name': 'centos_7', 'privileged': True})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'diff': [], 'dest': '/home/kad/.cache/molecule/vector-role/default/Dockerfile_centos_8', 'src': '/home/kad/.ansible/tmp/ansible-tmp-1656761418.174709-563786-58375149201688/source', 'md5sum': '71261693545dbbcef52e5eb77a8efd4d', 'checksum': '972df6af8ec1ae3177fbadc1ac9c9ac13267ca9c', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'kad', 'group': 'kad', 'mode': '0600', 'state': 'file', 'size': 449, 'invocation': {'module_args': {'src': '/home/kad/.ansible/tmp/ansible-tmp-1656761418.174709-563786-58375149201688/source', 'dest': '/home/kad/.cache/molecule/vector-role/default/Dockerfile_centos_8', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': '972df6af8ec1ae3177fbadc1ac9c9ac13267ca9c', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:8', 'name': 'centos_8', 'privileged': True, 'run': "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*\n"}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'diff': [], 'dest': '/home/kad/.cache/molecule/vector-role/default/Dockerfile_ubuntu_20_04', 'src': '/home/kad/.ansible/tmp/ansible-tmp-1656761418.5384865-563786-268595333799469/source', 'md5sum': '2daaf28ef59c56fadfbab800bea66ad1', 'checksum': 'b677e0c9d5703fc38a386e59657bd60c84a8ebb2', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'kad', 'group': 'kad', 'mode': '0600', 'state': 'file', 'size': 345, 'invocation': {'module_args': {'src': '/home/kad/.ansible/tmp/ansible-tmp-1656761418.5384865-563786-268595333799469/source', 'dest': '/home/kad/.cache/molecule/vector-role/default/Dockerfile_ubuntu_20_04', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': 'b677e0c9d5703fc38a386e59657bd60c84a8ebb2', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'command': '/sbin/init', 'dockerfile': 'Dockerfile.j2', 'env': {'DEBIAN_FRONTEND': 'noninteractive', 'TZ': 'Etc/GMT+5'}, 'image': 'ubuntu:20.04', 'name': 'ubuntu', 'privileged': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'diff': [], 'dest': '/home/kad/.cache/molecule/vector-role/default/Dockerfile_centos_7', 'src': '/home/kad/.ansible/tmp/ansible-tmp-1656761418.8059177-563786-150008037703884/source', 'md5sum': '4cad1fabf0d8d636fc21e8ff36a43c99', 'checksum': '2e713b3f1ef43d0465f155610a4e46297fc8b608', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'kad', 'group': 'kad', 'mode': '0600', 'state': 'file', 'size': 272, 'invocation': {'module_args': {'src': '/home/kad/.ansible/tmp/ansible-tmp-1656761418.8059177-563786-150008037703884/source', 'dest': '/home/kad/.cache/molecule/vector-role/default/Dockerfile_centos_7', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': '2e713b3f1ef43d0465f155610a4e46297fc8b608', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:7', 'name': 'centos_7', 'privileged': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
changed: [localhost] => (item=molecule_local/centos:8)
changed: [localhost] => (item=molecule_local/ubuntu:20.04)
changed: [localhost] => (item=molecule_local/centos:7)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:8', 'name': 'centos_8', 'privileged': True, 'run': "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*\n"})
ok: [localhost] => (item={'command': '/sbin/init', 'dockerfile': 'Dockerfile.j2', 'env': {'DEBIAN_FRONTEND': 'noninteractive', 'TZ': 'Etc/GMT+5'}, 'image': 'ubuntu:20.04', 'name': 'ubuntu', 'privileged': True})
ok: [localhost] => (item={'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:7', 'name': 'centos_7', 'privileged': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '674869233945.568353', 'results_file': '/home/kad/.ansible_async/674869233945.568353', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:8', 'name': 'centos_8', 'privileged': True, 'run': "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*\n"}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '714786666915.568379', 'results_file': '/home/kad/.ansible_async/714786666915.568379', 'changed': True, 'item': {'command': '/sbin/init', 'dockerfile': 'Dockerfile.j2', 'env': {'DEBIAN_FRONTEND': 'noninteractive', 'TZ': 'Etc/GMT+5'}, 'image': 'ubuntu:20.04', 'name': 'ubuntu', 'privileged': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '176581976282.568418', 'results_file': '/home/kad/.ansible_async/176581976282.568418', 'changed': True, 'item': {'command': '/usr/sbin/init', 'dockerfile': 'Dockerfile.j2', 'image': 'centos:7', 'name': 'centos_7', 'privileged': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=7    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos_8]
ok: [centos_7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Vector Install] ********************************************
included: /home/kad/studing/vector-role/tasks/install.yml for centos_7, centos_8, ubuntu

TASK [vector-role : Vector Install package for CentOS] *************************
skipping: [ubuntu]
changed: [centos_7]
changed: [centos_8]

TASK [vector-role : Vector Install package for Ubuntu] *************************
skipping: [centos_7]
skipping: [centos_8]
Selecting previously unselected package vector.
(Reading database ... 8649 files and directories currently installed.)
Preparing to unpack .../vector_0.21.2-1_amd64tuppvhma.deb ...
Unpacking vector (0.21.2-1) ...
Setting up vector (0.21.2-1) ...
systemd-journal:x:102:
changed: [ubuntu]

TASK [vector-role : Vector Configure] ******************************************
--- before
+++ after: /home/kad/.ansible/tmp/ansible-local-5690918j804m06/tmpazw2o0r2/vector.yml.j2
@@ -0,0 +1,18 @@
+sinks:
+    to_clickhouse:
+        compression: gzip
+        database: logs
+        endpoint: http://127.0.0.1:8123
+        healthcheck: false
+        inputs:
+        - our_log
+        skip_unknown_fields: true
+        table: my_table
+        type: clickhouse
+sources:
+    our_log:
+        ignore_older_secs: 600
+        include:
+        - /var/log/**/*.log
+        read_from: beginning
+        type: file

changed: [ubuntu]
--- before
+++ after: /home/kad/.ansible/tmp/ansible-local-5690918j804m06/tmppukg4nao/vector.yml.j2
@@ -0,0 +1,18 @@
+sinks:
+    to_clickhouse:
+        compression: gzip
+        database: logs
+        endpoint: http://127.0.0.1:8123
+        healthcheck: false
+        inputs:
+        - our_log
+        skip_unknown_fields: true
+        table: my_table
+        type: clickhouse
+sources:
+    our_log:
+        ignore_older_secs: 600
+        include:
+        - /var/log/**/*.log
+        read_from: beginning
+        type: file

changed: [centos_8]
--- before
+++ after: /home/kad/.ansible/tmp/ansible-local-5690918j804m06/tmpieung4am/vector.yml.j2
@@ -0,0 +1,18 @@
+sinks:
+    to_clickhouse:
+        compression: gzip
+        database: logs
+        endpoint: http://127.0.0.1:8123
+        healthcheck: false
+        inputs:
+        - our_log
+        skip_unknown_fields: true
+        table: my_table
+        type: clickhouse
+sources:
+    our_log:
+        ignore_older_secs: 600
+        include:
+        - /var/log/**/*.log
+        read_from: beginning
+        type: file

changed: [centos_7]

TASK [vector-role : Vector Service] ********************************************
--- before
+++ after: /home/kad/.ansible/tmp/ansible-local-5690918j804m06/tmpzqltr7pf/vector.service.j2
@@ -0,0 +1,11 @@
+[Unit]
+Description=Vector service
+After=network.target
+Requires=network-online.target
+[Service]
+User=root
+Group=0
+ExecStart=/usr/bin/vector --config-yaml vector.yml --watch-config
+Restart=always
+[Install]
+WantedBy=multi-user.target
\ No newline at end of file

changed: [centos_7]
--- before
+++ after: /home/kad/.ansible/tmp/ansible-local-5690918j804m06/tmp1o0olicn/vector.service.j2
@@ -0,0 +1,11 @@
+[Unit]
+Description=Vector service
+After=network.target
+Requires=network-online.target
+[Service]
+User=root
+Group=0
+ExecStart=/usr/bin/vector --config-yaml vector.yml --watch-config
+Restart=always
+[Install]
+WantedBy=multi-user.target
\ No newline at end of file

changed: [ubuntu]
--- before
+++ after: /home/kad/.ansible/tmp/ansible-local-5690918j804m06/tmpiyjohpxm/vector.service.j2
@@ -0,0 +1,11 @@
+[Unit]
+Description=Vector service
+After=network.target
+Requires=network-online.target
+[Service]
+User=root
+Group=0
+ExecStart=/usr/bin/vector --config-yaml vector.yml --watch-config
+Restart=always
+[Install]
+WantedBy=multi-user.target
\ No newline at end of file

changed: [centos_8]

RUNNING HANDLER [vector-role : start_vector] ***********************************
changed: [centos_7]
changed: [ubuntu]
changed: [centos_8]

NO MORE HOSTS LEFT *************************************************************

PLAY RECAP *********************************************************************
centos_7                   : ok=5    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
centos_8                   : ok=6    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=6    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos_8)
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
 ```
 </details>

## Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

### Ответ:

- Ссылка на репозиторий: https://github.com/AlexeyKhrapov/vector-role
 - Ссылка на версию с тестированием molecule: https://github.com/AlexeyKhrapov/vector-role/releases/tag/1.2.1
 <details><summary>Вывод команды `tox`</summary>

```bash
[root@896a16f0b551 vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.1,arrow==1.2.2,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.0,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,docker==5.0.3,enrich==1.2.7,idna==3.3,importlib-metadata==4.12.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-docker==1.1.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,typing_extensions==4.3.0,urllib3==1.26.9,wcmatch==8.4,websocket-client==1.3.3,yamllint==1.20.0,zipp==3.8.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='4018653229'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
INFO     Guessed /opt/vector-role as project root directory
WARNING  Computed fully qualified role name of vector_role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '574049297558.10057', 'results_file': '/root/.ansible_async/574049297558.10057', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="host registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=host)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="host command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=host: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=host)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=host)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [host]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Vector Install] ********************************************
included: /opt/vector-role/tasks/install.yml for host

TASK [vector-role : Vector Install package for CentOS] *************************
changed: [host]

TASK [vector-role : Vector Install package for Ubuntu] *************************
skipping: [host]

TASK [vector-role : Vector Configure] ******************************************
[WARNING]: The value "0" (type int) was converted to "u'0'" (type string). If
this does not look like what you expect, quote the entire value to ensure it
does not change.
changed: [host]

TASK [vector-role : Vector Service] ********************************************
changed: [host]

RUNNING HANDLER [vector-role : start_vector] ***********************************
skipping: [host]

PLAY RECAP *********************************************************************
host                       : ok=5    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '849436986114.11300', 'results_file': '/root/.ansible_async/849436986114.11300', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.1,arrow==1.2.2,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.0,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,docker==5.0.3,enrich==1.2.7,idna==3.3,importlib-metadata==4.12.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-docker==1.1.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,typing_extensions==4.3.0,urllib3==1.26.9,wcmatch==8.4,websocket-client==1.3.3,yamllint==1.20.0,zipp==3.8.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='4018653229'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
INFO     Guessed /opt/vector-role as project root directory
WARNING  Computed fully qualified role name of vector_role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '484446090151.11455', 'results_file': '/root/.ansible_async/484446090151.11455', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="host registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=host)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="host command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=host: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=host)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=host)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [host]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Vector Install] ********************************************
included: /opt/vector-role/tasks/install.yml for host

TASK [vector-role : Vector Install package for CentOS] *************************
changed: [host]

TASK [vector-role : Vector Install package for Ubuntu] *************************
skipping: [host]

TASK [vector-role : Vector Configure] ******************************************
[WARNING]: The value "0" (type int) was converted to "u'0'" (type string). If
this does not look like what you expect, quote the entire value to ensure it
does not change.
changed: [host]

TASK [vector-role : Vector Service] ********************************************
changed: [host]

RUNNING HANDLER [vector-role : start_vector] ***********************************
skipping: [host]

PLAY RECAP *********************************************************************
host                       : ok=5    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '755652574077.12675', 'results_file': '/root/.ansible_async/755652574077.12675', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.1.0,ansible-lint==5.1.1,arrow==1.2.2,attrs==21.4.0,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.0,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,docker==5.0.3,enrich==1.2.7,idna==3.3,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.6.1,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-docker==1.1.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,urllib3==1.26.9,wcmatch==8.4,websocket-client==1.3.3,yamllint==1.20.0
py39-ansible210 run-test-pre: PYTHONHASHSEED='4018653229'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
WARNING  Computed fully qualified role name of vector_role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '847473611944.12878', 'results_file': '/root/.ansible_async/847473611944.12878', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="host registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=host)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="host command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=host: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=host)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=host)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [host]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Vector Install] ********************************************
included: /opt/vector-role/tasks/install.yml for host

TASK [vector-role : Vector Install package for CentOS] *************************
changed: [host]

TASK [vector-role : Vector Install package for Ubuntu] *************************
skipping: [host]

TASK [vector-role : Vector Configure] ******************************************
[WARNING]: The value "0" (type int) was converted to "u'0'" (type string). If
this does not look like what you expect, quote the entire value to ensure it
does not change.
changed: [host]

TASK [vector-role : Vector Service] ********************************************
changed: [host]

RUNNING HANDLER [vector-role : start_vector] ***********************************
skipping: [host]

PLAY RECAP *********************************************************************
host                       : ok=5    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '191075702318.14063', 'results_file': '/root/.ansible_async/191075702318.14063', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==2.1.0,ansible-lint==5.1.1,arrow==1.2.2,attrs==21.4.0,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.0,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,docker==5.0.3,enrich==1.2.7,idna==3.3,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.6.1,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-docker==1.1.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,urllib3==1.26.9,wcmatch==8.4,websocket-client==1.3.3,yamllint==1.20.0
py39-ansible30 run-test-pre: PYTHONHASHSEED='4018653229'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
WARNING  Computed fully qualified role name of vector_role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

INFO     Using /root/.cache/ansible-lint/b984a4/roles/vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '881580208673.14190', 'results_file': '/root/.ansible_async/881580208673.14190', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="host registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=host)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="host command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=host: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=host)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=host)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [host]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Vector Install] ********************************************
included: /opt/vector-role/tasks/install.yml for host

TASK [vector-role : Vector Install package for CentOS] *************************
changed: [host]

TASK [vector-role : Vector Install package for Ubuntu] *************************
skipping: [host]

TASK [vector-role : Vector Configure] ******************************************
[WARNING]: The value "0" (type int) was converted to "u'0'" (type string). If
this does not look like what you expect, quote the entire value to ensure it
does not change.
changed: [host]

TASK [vector-role : Vector Service] ********************************************
changed: [host]

RUNNING HANDLER [vector-role : start_vector] ***********************************
skipping: [host]

PLAY RECAP *********************************************************************
host                       : ok=5    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '699534708729.15384', 'results_file': '/root/.ansible_async/699534708729.15384', 'changed': True, 'failed': False, 'item': {'image': 'pycontribs/centos:7', 'name': 'host', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
_________________________________________________________________________________________________________________________________________________ summary _________________________________________________________________________________________________________________________________________________
  py37-ansible210: commands succeeded
  py37-ansible30: commands succeeded
  py39-ansible210: commands succeeded
  py39-ansible30: commands succeeded
  congratulations :)
```

 </details>