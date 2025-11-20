# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

Ошибки есть:

<img width="1654" height="935" alt="image" src="https://github.com/user-attachments/assets/95bb283e-4ebc-4361-b5c7-b07e661b4969" />

Исправлены, passed

<img width="1743" height="88" alt="image" src="https://github.com/user-attachments/assets/1328565d-4b29-4fa7-a1ea-493e4e0e6e40" />

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
Добавил `when: not ansible_check_mode` к блокам, чтобы не ломали чек

Успешный чек:

<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/5995c32d-78d8-4dad-86b2-b622c6b7d48e" />

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Дифф отказался качать вектор из-за блокировок российского айпи, пришлось сделать фальшивый вектор локально.
Теперь дифф работает:

<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/42c72665-7128-4f68-a092-56408f4a7035" />

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Повторный дифф не отличается:

<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/2f521ff9-2d36-41d8-921c-1f4821149c93" />

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook). Так же приложите скриншоты выполнения заданий №5-8
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Приложите ссылку на ваше решение в поле "Ссылка на решение" и нажмите "Отправить решение"

---
