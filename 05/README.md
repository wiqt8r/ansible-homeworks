# Домашнее задание к занятию 5 «Тестирование roles»

**Примечание преподавателям:**
Тут всё рассчитано на очень старую молекулу и не работает так, как написано. Даже первый пункт из "Подготовки" не выполняется, команды из заданий тоже ломаются на актуальной молекуле. Пришлось идти обходным путём и делать всё в контейнере, так хотя бы удалось запустить старую молекулу.


### Molecule

Команда `molecule test -s ubuntu_xenial` отрабатывает

<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/65a4bcbe-0d3a-41eb-8215-6dd755e64fb2" />

Сценарий инициализирован:
<img width="1984" height="413" alt="image" src="https://github.com/user-attachments/assets/9f75d7ba-64c8-43f7-af4b-aa4c7bfb9f18" />

Тестовый прогон:
<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/d5dfd5dd-1d38-41ba-9a69-7428ccaa7172" />

Были ошибки на доступе в ansible-galaxy, Пришлось сильно залезть в molecule.yml и converge.yml. Пришлось повозиться с ошибками вроде `fatal: [oraclelinux8]: FAILED! => {"msg": "docker command not found in PATH"}`

На этом этапе мне надоело сражаться со сломанными зависимостями и недоступными репозиториями, я настроил _сами-понимаете-что_ на сервере для доступа к ansible-galaxy в обход блокировок.

После некотрых доработок в роли, конверж наконец-то прошел без ошибок

<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/6c5a3498-3b57-4dbf-8f7d-d6933dc9d167" />
<img width="1988" height="552" alt="image" src="https://github.com/user-attachments/assets/61a4dd67-a9d7-4311-a341-18e9461e1e88" />

Прогон `molecule test -s default` пройден
<img width="1984" height="1144" alt="image" src="https://github.com/user-attachments/assets/916cc195-1198-4fef-a7f8-0b7b87fb92d5" />

Написан `molecule/default/verify.yml`:
<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/e3ce3d73-c4eb-494d-a045-ba8dbc38a27c" />

Повторный прогон тестирования успешен:
<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/fd6bfb5c-2e50-49b5-8069-3789aef6f0bb" />

Сделан коммит с версией 0.2.0.

### Tox

Контейнер запущен, команда `tox` выполнена, вывод:
<img width="2009" height="1294" alt="image" src="https://github.com/user-attachments/assets/ef26006c-fe10-4824-8b23-a152755cdf5f" />
<img width="1987" height="400" alt="image" src="https://github.com/user-attachments/assets/b40f645b-7c80-4720-8847-8b36b0587f73" />

Создан сценарий molecule с драйвером podman
`molecule/podman/molecule.yml`
<img width="1985" height="646" alt="image" src="https://github.com/user-attachments/assets/1e83b8c6-4483-4cc6-85ac-bc531abddbd7" />

`molecule/podman/converge.yml`
<img width="1988" height="222" alt="image" src="https://github.com/user-attachments/assets/6ee1b36c-83c5-4774-a887-1cff0b399f08" />

`molecule/podman/verify.yml`
<img width="1984" height="817" alt="image" src="https://github.com/user-attachments/assets/d5bc8718-6c8f-4866-8a86-f15dddfd3e6f" />


6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
