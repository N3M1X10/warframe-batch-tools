# 🔁Быстрый перезапуск Warframe

## Перезапуск для Steam версии (запуск без вызова Steam)

>[!tip]
> - Скачать репозиторий целиком: [Download ZIP](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)
> - Чтобы скачать отдельные файлы: [Ищем такую кнопку](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). А за подробностями [Сюда](https://docs.github.com/ru/get-started/start-your-journey/downloading-files-from-github) или [Сюда](https://blog.skillfactory.ru/kak-skachivat-s-github/)
> - Для редактирования скачанного на вашем ПК bat-файла: **`ПКМ` -> `Изменить`**



> [!warning]
> Укажите **свой** путь к Warframe перед запуском этих файлов!
>
> Пример:
> ```bat
> set warframe=C:\Program Files (x86)\Steam\steamapps\common\Warframe
> ```

> [!tip]
> ### Если вам требуется запускать Warframe через Steam
>```bat
>set without_steam=0
>```

## 📁Файлы

### **Батники для Steam**
- [**`restart-warframe-steam.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/restart-warframe-steam.bat) - Перезапустить Warframe

### **Батники для отдельного лаунчера**
- [**`restart-warframe-launcher.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/restart-warframe-launcher.bat) - Перезапустить Warframe

### 🔵AlecaFrame
> [!warning]
> Укажите свой путь к Overwolf перед запуском этого файла!
> Пример:
> ```bat
> set overwolf=C:\Program Files\overwolf
> ```
> - [**`start-Aleca-Frame.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/bin/other/aleca-frame/start-Aleca-Frame.bat) - Запустить AlecaFrame
- [**`kill-overwolf.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/bin/other/aleca-frame/kill-overwolf.bat) - Закрыть Overwolf

### ❌Shutdown
- [**`kill-warframe-and-overwolf.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/bin/other/kill/kill-warframe-and-overwolf.bat) - Закрыть Warframe и Overwolf
- [**`kill-warframe.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/bin/other/kill/kill-warframe.bat) - Завершить процесс `Warframe.x64.exe`

### ⚠️Экспериментальные опции
- [**`warframe-cpu-priority.ps1`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/bin/warframe-cpu-priority.ps1) - этот пакет отвечает за изменение приоритета процесса Warframe. Если данного пакета не будет в директории - функция не сработает

## ⚙️Change CPU Priority on Launch
Установить для процесса Warframe приоритет CPU, при каждом запуске игры через пакеты перезапуска этого репозитория

> [!caution]
> **Внимание! Опция для опытных пользователей! Данный метод может повлиять на стабильность системы!**

1. Для включения опции, в пакете перезапуска (например `restart-warframe-launcher.bat`) - найдите переменную `change_priority` и установите `1`
```bat
set change_priority=1
```

2. Затем в `warframe-cpu-priority.ps1` измените переменную `$Priority` на нужное вам значение

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
