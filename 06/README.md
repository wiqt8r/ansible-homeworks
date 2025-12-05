# Домашнее задание к занятию 6 «Создание собственных модулей»

## Подготовка к выполнению
Сделана успешно с первого раза - даже неожиданно послен предыдущего задания.

## Основная часть

Здесь внезапно ПО в задании оказалось слишком новым)) У меня на Дебиане 12 не оказалось питона 3.12, пришлост установить.

Проверка module на исполняемость локально - успех:
<img width="1986" height="1031" alt="image" src="https://github.com/user-attachments/assets/fd63ab27-a894-445b-a8bd-401f737f7247" />


Создан single task playbook `my_own_module_play.yml` с использованием module в нём.
```
---
- name: Test my_own_module via playbook
  hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Create file using my_own_module
      my_own_module:
        path: /tmp/test_from_playbook.txt
        content: "hello from playbook"
```
Запускается, идемпотентен:
<img width="1982" height="820" alt="image" src="https://github.com/user-attachments/assets/74fa73d9-547b-4455-9602-33e8fa50925d" />



Шаг 12 выполнен, коллекция выложена в репозиторий с тегом `1.0.0`: https://github.com/wiqt8r/my_own_collection

Шаг 13 выполнен, tar.gz архив помещен в субдиректорию build: https://github.com/wiqt8r/my_own_collection/tree/main/build

Шаг 15 выполнен, collection установлена:
<img width="1987" height="262" alt="image" src="https://github.com/user-attachments/assets/819519b2-8090-4785-9e81-a81e7443f3a4" />

Шаг 16 выполнен, плейбук запущен и работает:
<img width="1988" height="543" alt="image" src="https://github.com/user-attachments/assets/ffee3d9f-0c8d-46e7-b2f3-41cb2ec56dea" />

Шаг 17 - всё тут)


