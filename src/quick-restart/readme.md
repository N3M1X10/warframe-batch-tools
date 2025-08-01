### 📕readme.md

<!-- <p align="left">
   <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/warframe/readme.md">
      <img width="96" alt="warframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/warframe-badge-hl.png">
   </a>
  <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/soulframe/readme.md">
      <img width="96" alt="soulframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/soulframe-badge.png">
   </a>
</p> -->

# 🔁Быстрый перезапуск Warframe или Soulframe

>[!tip]
>- Скачать репозиторий целиком: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)
>- Скачать из релизов: [**`Releases`**](https://github.com/N3M1X10/warframe-batch-tools/releases)
>- Если требуется скачать отдельные файлы: [Ищем такую кнопку](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). А за подробностями [Сюда](https://docs.github.com/ru/get-started/start-your-journey/downloading-files-from-github) или [Сюда](https://blog.skillfactory.ru/kak-skachivat-s-github/)

## Важные примечания по параметрам

>[!tip]
> ### Кратко о переменных
>Внутри скриптов есть переменные (т.е. настройки и опции)
>>Блок переменной выглядят как:
>>```bat
>>:: description
>>set name=value
>>```
>>- Где `set` - командлет присвоения переменной
>>- Где вместо `name` - имя переменной
>>- Где вместо `value` - значение переменной
>>- Где вместо `description` - комментарий с описанием к этой переменной
>
>- Редактируя их, можно конфигурировать поведение скрипта при перезапуске
>
>- Для редактирования скачанного на вашем ПК пакетного скрипта: **`ПКМ` -> `Изменить`**
>
>- Внимательно смотрите на примеры переменных. Это поможет вам избежать ошибок в работе скрипта


>[!warning]
>### Если вы хотите запускать игру через Steam
>Вам потребуется установить значение следующей переменной так: 
>```bat
>set launch_type=steam 
>```


>[!tip]
>### Запуск игры без пробуждения Steam
>Если вы хотите чтобы Warframe запускался без пробуждения Steam (запустить лаунчер игры отдельно)
>
>Переменная должна выглядеть так:
>```bat
>set without_waking_up_steam=1
>```
>
>>Перед использованием этой опции: обязательно установите `set launch_type=steam` и укажите **свой** путь к Warframe перед запуском скрипта!
>>
>>Пример пути:
>>```bat
>>set steam_warframe_path=C:\Program Files (x86)\Steam\steamapps\common\Warframe
>>```
>> В противном случае, применить параметры тихого запуска - скрипт не сможет. Он попытается запустить игру через отдельный лаунчер в localappdata, а если его там нет - выдаст ошибку


>[!note]
>Остальные переменные c их описанием - есть внутри самого скрипта (возможно позже, опишу их тут)


## 📁Файлы

- **`restart-warframe-united.bat`** - Пакетный скрипт перезапуска Warframe, с различными дополнениями (функциями)
- **`restart-soulframe-united.bat`** - Такой же пакетный скрипт перезапуска но для Soulframe
- Папка **`bin`** - сборка дополнительных скриптов для работы основного скрипта перезапуска и прочий мусор. О них можно прочесть ниже.

### ⚠️Дополнительные опции перезапуска
- **`bin\powershell\cpu-priority\cpu-priority.ps1`** - Это Powershell скрипт, который отвечает за изменение приоритета процесса выбранной вами игры. 
  - Если данного пакетного файла не будет в директории - функция не сработает.
    - Указать свой путь к этому скрипту вы всегда можете внутри пакетных скриптов перезапуска, А ТАКЖЕ внутри скриптов ручного запуска.
- **`bin\powershell\cpu-priority\apply-warframe-cpu-priority.bat`** - Пакетный скрипт для ручного запуска Powershell-скрипта, с параметрами для Warframe
- **`bin\powershell\cpu-priority\apply-soulframe-cpu-priority.bat`** - Пакетный скрипт для ручного запуска Powershell-скрипта, с параметрами для Soulframe

>[!note]
> Подробнеее о приоритете процесса - ниже

### 🔵AlecaFrame
> [!warning]
> - **`start-Aleca-Frame.bat`** - Запустить AlecaFrame
>> Укажите свой путь к Overwolf перед запуском этого файла!
>> Пример:
>> ```bat
>> set overwolf=C:\Program Files\overwolf
>> ```

- **`kill-overwolf.bat`** - Закрыть Overwolf

### ❌Shutdown
- **`bin\kill\kill-warframe-and-overwolf.bat`** - Закрыть Warframe и Overwolf
- **`bin\kill\kill-warframe.bat`** - Закрыть Warframe вместе с лаунчером
- **`bin\kill\kill-soulframe.bat`** - Закрыть Soulframe вместе с лаунчером


## ⚙️Изменение приоритета процесса при запуске
Вы можете установить для процесса Warframe приоритет CPU, при каждом запуске игры через пакетный скрипт перезапуска, этого репозитория

> [!caution]
> **Внимание! Опция для опытных пользователей! Данный метод может повлиять на стабильность системы!**

### Как включить и настроить?

1. Для включения опции, в скрипте перезапуска, например в: `restart-warframe-united.bat` -> пкм - изменить -> найдите переменную `change_priority` и установите `1`

>[!note]
>Пример:
>```bat
>set change_priority=1
>```

2. Затем в скрипте перезапуска, например в: `restart-warframe-united.bat` -> пкм - изменить -> поменяйте значение переменной `priority` на нужное вам
>[!tip]
>Разрешённые значения:
>- `low` - Низкий
>- `BelowNormal` - Ниже среднего
>- `normal` - Обычный
>- `AboveNormal` - Выше среднего
>- `high` - Высокий               
>- `realtime` - Реального времени

>[!note]
>Пример:
>```bat
>set priority=high
>```

### Как это работает?
- Когда вы запускаете пакетный файл перезапуска игры - он запускает скрипт powershell (`bin\warframe-cpu-priority.ps1`), который в фоне - выполняет отслеживание запуска окна игры. Как только он увидит окно игры - применит приоритет процесса, который вы указали в настройках powershell скрипта.
- Если вы не зашли в игру, а закрыли лаунчер - скрипт завершится в фоне сам.

>[!tip]
>- Если вы закроете окно лаунчера - скрипт завершит выполнение. Для запуска функции, потребуется повторный запуск: либо - через пакетный файл перезапуска, либо напрямую - через powershell скрипт в соответствующей папке

## 💻User Account Control
Для отключения уведомлений системы защиты при запуске файлов репозитория можно обратиться сюда:
- [**`windows-batch/src/net/uac`**](https://github.com/N3M1X10/windows-batch/tree/master/src/system-policies/uac)

Это упростит и ускорит работу с скриптами репозитория

