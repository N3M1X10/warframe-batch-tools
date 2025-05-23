### 📕readme.md
<p align="left">
   <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/warframe/readme.md">
      <img width="96" alt="warframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/warframe-badge-hl.png">
   </a>
  <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/soulframe/readme.md">
      <img width="96" alt="soulframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/soulframe-badge.png">
   </a>
</p>

# 🔁Быстрый перезапуск Warframe

>[!tip]
> - Скачать репозиторий целиком: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)
> - Чтобы скачать отдельные файлы: [Ищем такую кнопку](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). А за подробностями [Сюда](https://docs.github.com/ru/get-started/start-your-journey/downloading-files-from-github) или [Сюда](https://blog.skillfactory.ru/kak-skachivat-s-github/)
> - Для редактирования скачанного на вашем ПК bat-файла: **`ПКМ` -> `Изменить`**

## Перезапуск для Steam версии (запуск без вызова Steam)

> [!warning]
> Укажите **свой** путь к Warframe перед запуском этого файла!
>
> Пример:
> ```bat
> set warframe=C:\Program Files (x86)\Steam\steamapps\common\Warframe
> ```

> [!tip]
> ### Если вы хотите чтобы Warframe запускался через Steam
>```bat
>set without_steam=0
>```
> - По умолчанию эта функция включена, так как подразумевается **быстрый** перезапуск игры, а не нудятина с пробуждением Steam

## 📁Файлы

### **Пакетные файлы для Steam**
- **`restart-warframe-steam.bat`** - Перезапустить Warframe

### **Пакетные файлы для отдельного лаунчера**
- **`restart-warframe-launcher.bat`** - Перезапустить Warframe

### 🔵AlecaFrame
> [!warning]
> Укажите свой путь к Overwolf перед запуском этого файла!
> Пример:
> ```bat
> set overwolf=C:\Program Files\overwolf
> ```
> - **`start-Aleca-Frame.bat`** - Запустить AlecaFrame
- **`kill-overwolf.bat`** - Закрыть Overwolf

### ❌Shutdown
- **`bin\kill\kill-warframe-and-overwolf.bat`** - Закрыть Warframe и Overwolf
- **`bin\kill\kill-warframe.bat`** - Закрыть Warframe вместе с лаунчером

### ⚠️Экспериментальные опции
- **`bin\warframe-cpu-priority.ps1`** - это powershell скрипт, который отвечает за изменение приоритета процесса Warframe. Если данного пакетного файла не будет в директории - функция не сработает
- **`bin\apply-warframe-cpu-priority.bat`** - пакетный файл для ручного запуска powershell скрипта

## ⚙️Изменение приоритета процесса при запуске
Установить для процесса Warframe приоритет CPU, при каждом запуске игры через пакетный файл перезапуска этого репозитория

> [!caution]
> **Внимание! Опция для опытных пользователей! Данный метод может повлиять на стабильность системы!**

### Как включить и настроить?

1. Для включения опции, в пакетном файле перезапуска (`restart-warframe-launcher.bat`) -> пкм -> изменить -> найдите переменную `change_priority` и установите `1`

```bat
set change_priority=1
```

2. Затем в `bin\warframe-cpu-priority.ps1` -> пкм - изменить -> поменяйте значение переменной `$Priority` на нужное вам

Разрешённые значения:

- `low` - Низкий
- `BelowNormal` - Ниже среднего
- `normal` - Обычный
- `AboveNormal` - Выше среднего
- `high` - Высокий               
- `realtime` - Реального времени

Пример:
```ps1
$Priority = "high"
```

### Как это работает?
Когда вы запускаете пакетный файл перезапуска игры (`restart-warframe-***.bat`) - он запускает скрипт powershell (`bin\warframe-cpu-priority.ps1`), который в фоне - выполняет отслеживание запуска окна игры. Как только он увидит окно игры - применит приоритет процесса, который вы указали в настройках powershell скрипта.

>[!tip]
>- Если вы закроете окно лаунчера - скрипт завершит выполнение. Потребуется повторный запуск: либо - через пакетный файл перезапуска, либо напрямую - через powershell скрипт в соответствующей папке

## 💻User Account Control
Для отключения уведомлений системы защиты при запуске файлов репозитория можно обратиться сюда:
- [**`windows-batch/src/net/uac`**](https://github.com/N3M1X10/windows-batch/tree/master/src/system-policies/uac)
