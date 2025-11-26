# Ansible Playbook: ClickHouse, Vector, Lighthouse

[![Ansible](https://img.shields.io/badge/ansible-2.12+-blue.svg)](https://ansible.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Данный Ansible playbook автоматизирует установку и настройку комплексного решения для сбора, обработки и визуализации данных:

- **ClickHouse** — система управления базами данных columnar типа для аналитики
- **Vector** — высокопроизводительный инструмент для сбора, обработки и передачи логов и метрик
- **Lighthouse** — веб-интерфейс для мониторинга и управления ClickHouse

## Описание проекта

Playbook рассчитан на работу с тремя группами хостов в Yandex Cloud (или любом другом окружении):

- `clickhouse` — сервер ClickHouse
- `vector` — сервер Vector для сбора логов
- `lighthouse` — веб-интерфейс для мониторинга

## Структура проекта

```
04/
├── inventory/
│   └── prod.yml
├── requirements.yml
├── roles/
│   ├── clickhouse/        # внешняя роль из GitHub
│   ├── vector-role/       # роль из репозитория wiqt8r/vector-role
│   └── lighthouse-role/   # роль из репозитория wiqt8r/lighthouse-role
├── site.yml
└── README.md
```

## Требования

- Ansible 2.12+
- Доступ к целевым хостам по SSH
- Права sudo на целевых хостах
- Поддерживаемые ОС:
  - Семейство RedHat (AlmaLinux, CentOS и т.п.)
  - Семейство Debian (для lighthouse-role)

## Установка зависимостей

Роли устанавливаются с помощью `ansible-galaxy` на основе файла `requirements.yml`:

```bash
ansible-galaxy install -r requirements.yml -p roles
```

### Файл requirements.yml

```yaml
---
- src: https://github.com/AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.13"
  name: clickhouse

- src: https://github.com/wiqt8r/vector-role.git
  scm: git
  version: "v0.1.0"
  name: vector-role

- src: https://github.com/wiqt8r/lighthouse-role.git
  scm: git
  version: "v0.1.0"
  name: lighthouse-role
```

## Настройка инвентаря

Файл `inventory/prod.yml` должен описывать три группы хостов:

```yaml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: <IP_clickhouse>

vector:
  hosts:
    vector-01:
      ansible_host: <IP_vector>

lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: <IP_lighthouse>
```

Подключение по SSH настраивается через `~/.ssh/config` и соответствующие ключи.

## Playbook site.yml

```yaml
---
- name: Install ClickHouse
  hosts: clickhouse
  roles:
    - role: clickhouse
  tags: [clickhouse]

- name: Install Vector
  hosts: vector
  roles:
    - role: vector-role
  tags: [vector]

- name: Install Lighthouse
  hosts: lighthouse
  roles:
    - role: lighthouse-role
  tags: [lighthouse]
  tasks:
    - name: Show ClickHouse HTTP endpoint for Lighthouse
      ansible.builtin.debug:
        msg: "ClickHouse is expected to be available at http://{{ hostvars['clickhouse-01'].ansible_host }}:8123"
```

Таким образом, Lighthouse разворачивается после ClickHouse и может использовать его как backend.

## Запуск playbook

### Проверка без внесения изменений

```bash
ansible-playbook -i inventory/prod.yml site.yml --check
```

### Запуск с показом изменений

```bash
ansible-playbook -i inventory/prod.yml site.yml --diff
```

Повторный запуск с `--diff` должен показывать идемпотентность (отсутствие изменений при повторном применении).

## Теги

Playbook поддерживает теги для запуска отдельных компонентов:

| Тег | Описание |
|-----|----------|
| `clickhouse` | Установка и настройка ClickHouse |
| `vector` | Установка и настройка Vector |
| `lighthouse` | Установка и настройка Lighthouse |

### Примеры использования тегов

```bash
ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse
ansible-playbook -i inventory/prod.yml site.yml --tags vector
ansible-playbook -i inventory/prod.yml site.yml --tags lighthouse
```

## Архитектура решения

1. **ClickHouse** — хранит и обрабатывает аналитические данные
2. **Vector** — собирает логи и метрики, может отправлять их в ClickHouse
3. **Lighthouse** — предоставляет веб-интерфейс для мониторинга ClickHouse

## Лицензия

Этот проект распространяется под лицензией MIT. Подробности смотрите в файле LICENSE.

## Автор

**wiqt8r** - [GitHub](https://github.com/wiqt8r)

## Благодарности

- [ClickHouse](https://clickhouse.com/) за мощную аналитическую СУБД
- [Vector](https://vector.dev/) за отличный инструмент для сбора логов
- [Lighthouse](https://github.com/VKCOM/lighthouse) за удобный веб-интерфейс
- [Ansible](https://ansible.com/) за автоматизацию инфраструктуры
