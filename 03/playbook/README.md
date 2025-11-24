# Ansible Playbook: ClickHouse, Vector, Lighthouse

## Общая информация

Данный репозиторий содержит Ansible-playbook, предназначенный для установки и настройки ClickHouse, Vector и Lighthouse на разных хостах. Playbook поддерживает режимы `--check`, `--diff`, обработчики изменений, работу через шаблоны Jinja2 и идемпотентность.

Функциональность разделена на три независимых play:

- установка ClickHouse на узлах группы `clickhouse`;
- установка Vector на узлах группы `vector`;
- установка Lighthouse на узлах группы `lighthouse`.

## Структура репозитория

```yaml
.
├── site.yml
├── inventory/
│   └── prod.yml
├── group_vars/
│   ├── clickhouse/
│   │   └── vars.yml
│   ├── lighthouse/
│   │   └── vars.yml
│   └── vector/
│       └── vars.yml
├── templates/
│   ├── lighthouse.conf.j2
│   ├── vector.yml.j2
│   └── vector.service.j2
├── files/
│   └── vector-<version>.tar.gz
├── clickhouse-client-22.3.3.44.rpm
├── clickhouse-common-static-22.3.3.44.rpm
├── clickhouse-server-22.3.3.44.rpm
└── README.md
```

## Inventory

Файл `inventory/prod.yml` описывает три хоста с подключением по SSH:

```yaml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 158.160.11.56
      ansible_user: wiqtor
      ansible_become: true
      ansible_ssh_private_key_file: ~/.ssh/yc_cloud

vector:
  hosts:
    vector-01:
      ansible_host: 89.169.168.252
      ansible_user: wiqtor
      ansible_become: true
      ansible_ssh_private_key_file: ~/.ssh/yc_cloud

lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 158.160.27.100
      ansible_user: wiqtor
      ansible_become: true
      ansible_ssh_private_key_file: ~/.ssh/yc_cloud
```

## Переменные

### ClickHouse (group_vars/clickhouse/vars.yml)

```yaml
clickhouse_version: "22.3.3.44"
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static
```

### Vector (group_vars/vector/vars.yml)

```yaml
vector_version: "0.51.1"
vector_install_dir: "/opt/vector"
vector_config_dir: "/etc/vector"
```

Для Vector используется локальный архив, размещённый в каталоге files/.

### Lighthouse (group_vars/lighthouse/vars.yml)

```yaml
lighthouse_repo_url: "https://github.com/VKCOM/lighthouse.git"
lighthouse_docroot: "/var/www/lighthouse"
lighthouse_nginx_conf: "/etc/nginx/conf.d/lighthouse.conf"
lighthouse_server_name: "_"
```

## Playbook - описание

### ClickHouse Play

Основные действия:

- скачивание RPM-пакетов через модуль get_url;
- копирование пакетов на целевой хост;
- установка пакетов через yum;
- запуск и перезапуск сервиса clickhouse-server;
- создание базы данных logs.

Использованные модули:

- get_url
- copy
- yum
- service
- command
- meta

### Vector Play

Основные действия:

- копирование локального архива Vector (copy);
- создание каталога установки /opt/vector;
- распаковка архива (unarchive);
- создание символьной ссылки на бинарный файл;
- размещение конфигурации через Jinja2-шаблон;
- размещение systemd unit-файла;
- выполнение systemd daemon-reload и запуск сервиса на хостах, не являющихся Docker-контейнерами.

Использованные модули:

- copy
- file
- unarchive
- template
- systemd
- service

### Lighthouse Play

Основные действия:

- установка nginx и git через yum/apt;
- создание каталога документации /var/www/lighthouse;
- клонирование репозитория Lighthouse из GitHub;
- развертывание конфигурации nginx через Jinja2-шаблон;
- запуск и включение сервиса nginx.

Использованные модули:

- yum
- apt
- file
- git
- template
- service

## Использование

Проверка без внесения изменений:

```bash
ansible-playbook -i inventory/prod.yml site.yml --check
```

Применение с отображением изменений:

```bash
ansible-playbook -i inventory/prod.yml site.yml --diff
```

Проверка идемпотентности:

```bash
ansible-playbook -i inventory/prod.yml site.yml --diff
```

Повторный запуск должен показать changed=0 по всем задачам.

Запуск для конкретной группы хостов:

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse
ansible-playbook -i inventory/prod.yml site.yml --tags vector
ansible-playbook -i inventory/prod.yml site.yml --tags lighthouse
```

## Ansible Lint

Команда:

```bash
ansible-lint site.yml
```

Плейбук подготовлен таким образом, чтобы соответствовать базовым требованиям ansible-lint.

## Заметки

В учебном окружении запуск осуществляется на реальных хостах Yandex Cloud через SSH подключение.

Для Vector используется локальный архив, поскольку сетевой доступ к официальным репозиториям может быть недоступен. Это не влияет на структуру или корректность выполнения playbook.

Lighthouse развертывается как система мониторинга от VK, работающая через Nginx.
