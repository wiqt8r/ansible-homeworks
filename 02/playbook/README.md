# Ansible Playbook: ClickHouse and Vector Deployment

## Overview

Данный репозиторий содержит Ansible-playbook, предназначенный для установки и настройки ClickHouse и Vector на разных группах хостов. Playbook поддерживает режимы `--check`, `--diff`, обработчики изменений, работу через шаблоны Jinja2 и идемпотентность.

Функциональность разделена на два независимых play:

- установка ClickHouse на узлах группы `clickhouse`;
- установка Vector на узлах группы `vector`.

## Repository Structure

```yaml
.
├── site.yml
├── inventory/
│   └── prod.yml
├── group_vars/
│   ├── clickhouse/
│   │   └── vars.yml
│   └── vector/
│       └── vars.yml
├── templates/
│   ├── vector.yml.j2
│   └── vector.service.j2
├── files/
│   └── vector-<version>.tar.gz
└── README.md
```

## Inventory

Файл `inventory/prod.yml` описывает два хоста, работающих через подключение `docker`:

```yaml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: docker

vector:
  hosts:
    vector-01:
      ansible_connection: docker
```

## Variables

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

## Playbook Description

### ClickHouse Play

Основные действия:

- скачивание RPM-пакетов через модуль get_url;
- резервная загрузка пакета в блоке rescue;
- установка пакетов через yum;
- запуск и перезапуск сервиса clickhouse-server;
- создание базы данных logs.

Использованные модули:

- get_url
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

## Usage

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

## Ansible Lint

Команда:

```bash
ansible-lint site.yml
```

Плейбук подготовлен таким образом, чтобы соответствовать базовым требованиям ansible-lint.

## Notes

В учебном окружении запуск осуществляется внутри Docker-контейнеров, поэтому задачи, связанные с systemd, выполняются только на реальных хостах и пропускаются в Docker.

Для Vector используется локальный архив, поскольку сетевой доступ к официальным репозиториям недоступен. Это не влияет на структуру или корректность выполнения playbook.
