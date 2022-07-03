# 08.04 Создание собственных modules

## Подготовка к выполнению
1. Создайте пустой публичных репозиторий в любом своём проекте: `my_own_collection`
2. Скачайте репозиторий ansible: `git clone https://github.com/ansible/ansible.git` по любому удобному вам пути
3. Зайдите в директорию ansible: `cd ansible`
4. Создайте виртуальное окружение: `python3 -m venv venv`
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении
6. Установите зависимости `pip install -r requirements.txt`
7. Запустить настройку окружения `. hacking/env-setup`
8. Если все шаги прошли успешно - выйти из виртуального окружения `deactivate`
9. Ваше окружение настроено, для того чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`

---

### **Ответ:**

Подготовка выполнена успешно.

---

## Основная часть

Наша цель - написать собственный module, который мы можем использовать в своей role, через playbook. Всё это должно быть собрано в виде collection и отправлено в наш репозиторий.

1. В виртуальном окружении создать новый `my_own_module.py` файл
2. Наполнить его содержимым из [статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.
---
### **Ответ:**

Заполненный файл: [my_own_module.py](./src/my_own_module.py)

<details><summary>Содержимое заполненного файла</summary>

```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_own_module

short_description: This is my own module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my own module as part of the homework 08-ansible-06-module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name
author:
    - Alexey Khrapov (@AlexeyKhrapov)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world
# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true
# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule
import os

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = {
        'path': {type: 'str', 'required': True},
        'content': {type: 'str', 'required': False, 'default': "Hello world!" }
    }

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = {
        'changed': False
    }

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    # result['original_message'] = module.params['name']
    # result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    # if module.params['new']:
    #     result['changed'] = True

    if not(os.path.exists(module.params['path']) 
    and os.path.isfile(module.params['path'])
    and open(module.params['path'],'r').read() == module.params['content']):
        try:
            with open(module.params['path'], 'w') as file:
                file.write(module.params['content'])
                result['changed'] = True
        except Exception as e:
            module.fail_json(msg=f"Something gone wrong: {e}", **result)

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['path'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```

</details>

---

4. Проверьте module на исполняемость локально.

---
### **Ответ:**

Файл с кодом запроса: [check.json](./src/check.json)

<details><summary>Содержимое файла с кодом запроса</summary>

```json
{
    "ANSIBLE_MODULE_ARGS": {
        "path": "test_file.txt",
        "content": "I'm test content"
    }
}
```

</details>

<details><summary>Результат выполнения</summary>

```bash
(venv) kad@g-deb-test:~/studing/ansible/ansible$ python -m ansible.modules.my_own_module checks/check.json 

{"changed": true, "invocation": {"module_args": {"path": "test_file.txt", "content": "I'm test content"}}}
(venv) kad@g-deb-test:~/studing/ansible/ansible$ python -m ansible.modules.my_own_module checks/check.json 

{"changed": false, "invocation": {"module_args": {"path": "test_file.txt", "content": "I'm test content"}}}
```
</details>

---

5. Напишите single task playbook и используйте module в нём.
6. Проверьте через playbook на идемпотентность.

---

### **Ответ:**

<details><summary>Содержимое playbook'а</summary>

```yaml
---
- name: my_own_module test
  hosts: localhost
  tasks:
  - name: my_own_module run
    my_own_module:
      path: './test_file.txt'
      content: "I'm test content"
```

</details>

<details><summary>Результат выполнения и повторного выполнения</summary>

```bash
(venv) kad@g-deb-test:~/studing/ansible/ansible$ ansible-playbook checks/test_module.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [my_own_module test] *********************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [my_own_module run] **********************************************************************************************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP ************************************************************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

(venv) kad@g-deb-test:~/studing/ansible/ansible$ ansible-playbook checks/test_module.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [my_own_module test] *********************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [my_own_module run] **********************************************************************************************************************************************************************************************************************************************************************************
ok: [localhost]

PLAY RECAP ************************************************************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

</details>

---

7. Выйдите из виртуального окружения.
8. Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`
9. В данную collection перенесите свой module в соответствующую директорию.
10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module
11. Создайте playbook для использования этой role.
12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.

---

### **Ответ:**

<details><summary>Playbook для использования созданной role</summary>>

```yaml
---
  - name: Collection playbook test
    hosts: localhost
    collections:
      - my_own_collection.yandex_cloud_cvl
    vars:
      - path: "./collection_test.txt"
      - content: "Test content"
    roles:
      - my_own_role
```

</details>

<details><summary>Зависимости для playbook'а</summary>>

```yaml
collections:
  - name: git@github.com:AlexeyKhrapov/my_own_collection.git#yandex_cloud_cvl
    type: git
    version: main
```

</details>

- [playbook.yml](./src/playbook.yml)

- [requirements.yml](./src/requirements.yml)

Ссылка на репозиторий с collection и single task role:

https://github.com/AlexeyKhrapov/my_own_collection/releases/tag/1.0.0

---

13. Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.

---

### **Ответ:**

<details><summary>Результат выполнения</summary>

```bash
kad@g-deb-test:~/studing/ansible/ansible/my_own_collection/yandex_cloud_cvl$ ansible-galaxy collection build
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
Created collection for my_own_collection.yandex_cloud_cvl at /home/kad/studing/ansible/ansible/my_own_collection/yandex_cloud_cvl/my_own_collection-yandex_cloud_cvl-1.0.0.tar.gz
```
</details>

---

14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
15. Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`

---

### **Ответ:**

<details><summary>Установка collection из локального архива в новую директорию</summary>

```bash
kad@g-deb-test:~/studing/ansible/ansible/my_own_collection/yandex_cloud_cvl/tests$ ansible-galaxy collection install my_own_collection-yandex_cloud_cvl-1.0.0.tar.gz 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'my_own_collection.yandex_cloud_cvl:1.0.0' to '/home/kad/.ansible/collections/ansible_collections/my_own_collection/yandex_cloud_cvl'
my_own_collection.yandex_cloud_cvl:1.0.0 was installed successfully
```
</details>

---

16. Запустите playbook, убедитесь, что он работает.

---

### **Ответ:**

<details><summary>Вывод запуска playbook'а</summary>

```bash
kad@g-deb-test:~/studing/ansible/ansible/my_own_collection/yandex_cloud_cvl/tests$ ansible-playbook playbook.yml 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Collection playbook test] ***********************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [my_own_collection.yandex_cloud_cvl.my_own_role : my_own_role test] ******************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP ********************************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

kad@g-deb-test:~/studing/ansible/ansible/my_own_collection/yandex_cloud_cvl/tests$ ls -l
итого 20
-rw-r--r-- 1 kad kad   12 июл  3 17:08 collection_test.txt
-rw-r--r-- 1 kad kad 5661 июл  3 16:44 my_own_collection-yandex_cloud_cvl-1.0.0.tar.gz
-rw-r--r-- 1 kad kad  230 июл  3 16:58 playbook.yml
-rw-r--r-- 1 kad kad  122 июл  3 16:57 requirements.yml
kad@g-deb-test:~/studing/ansible/ansible/my_own_collection/yandex_cloud_cvl/tests$ cat collection_test.txt 
Test content
```

</details>

---

17. В ответ необходимо прислать ссылку на репозиторий с collection

---

### **Ответ:**

https://github.com/AlexeyKhrapov/my_own_collection/tree/main/yandex_cloud_cvl