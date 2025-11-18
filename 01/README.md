# Домашнее задание к занятию 1 «Введение в Ansible»

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

<img width="1601" height="547" alt="image" src="https://github.com/user-attachments/assets/1cfd8d67-b1bf-4ff7-98c4-9233c7ba22ce" />

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

<img width="1189" height="417" alt="image" src="https://github.com/user-attachments/assets/9f3ef019-cc5b-4c4d-bf45-807fe8f488b4" />

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
Значения some fact:
centos7	el
ubuntu	deb

<img width="1772" height="762" alt="image" src="https://github.com/user-attachments/assets/24af270f-27fd-4c5f-941c-ba88c7d03837" />

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

<img width="1986" height="750" alt="image" src="https://github.com/user-attachments/assets/d1519406-bd82-4181-bd4a-629e87d00f17" />

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

<img width="1732" height="1004" alt="image" src="https://github.com/user-attachments/assets/40508985-f30a-4bff-a59a-934dbc936476" />

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
> Подходящий плагин для работы на control node: local

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

<img width="1790" height="1004" alt="image" src="https://github.com/user-attachments/assets/d19e9eb3-ab22-4ae6-9571-08a13c7d6b03" />

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
13. Предоставьте скриншоты результатов запуска команд.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

<img width="1987" height="332" alt="image" src="https://github.com/user-attachments/assets/20b5dca8-0a4c-4727-8e80-0251c5955bc1" />

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

<img width="1986" height="1005" alt="image" src="https://github.com/user-attachments/assets/63482810-e4a3-4729-b052-42b082483303" />

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).

<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/68ef418f-de33-4721-96d9-94b051c0684e" />

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```
#!/bin/bash

VAULT_PASS="netology"

create_container() {
    NAME=$1
    IMAGE=$2
    PY_SETUP=$3

    echo "Creating container $NAME from image $IMAGE..."
    docker run -d --name $NAME $IMAGE sleep infinity

    echo "Installing Python in $NAME..."
    docker exec -it $NAME bash -c "$PY_SETUP"
}

# CentOS 7
create_container centos7 centos:7 "
sed -i 's|mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo && \
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo && \
yum clean all && yum makecache && yum install -y python
"

# Ubuntu
create_container ubuntu ubuntu:22.04 "
apt update && apt install -y python3 && ln -sf /usr/bin/python3 /usr/bin/python
"

# Fedora
create_container fedora01 fedora:38 "
dnf install -y python3 && ln -sf /usr/bin/python3 /usr/bin/python
"

# Запуск playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file <(echo "$VAULT_PASS")

# Остановка контейнеров
echo "Stopping and removing containers..."
docker rm -f centos7 ubuntu fedora01

echo "Done!"
```
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---

### Как оформить решение задания

Приложите ссылку на ваше решение в поле «Ссылка на решение» и нажмите «Отправить решение»
---
