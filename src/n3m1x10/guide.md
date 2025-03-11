# Быстрый перезапуск Warframe

## Перезапуск для Steam версии (запуск без вызова Steam)

>[!tip]
>Для открытия файла в режиме редактирования: ПКМ -> "Изменить"

> [!warning]
> ### Укажите **свой** путь к Warframe перед запуском этих файлов!
>
> ### Примеры:
> 
> Для Warframe
> ```
> set warframe=C:\Program Files (x86)\Steam\steamapps\common\Warframe
> ```
>
> Для Overwolf
> ```
> set overwolf=C:\Program Files\overwolf
> ```

> [!tip]
> ### Если вам требуется запускать Warframe через Steam
>```
>set without_steam=0
>```

## Файлы

### **Батники для Steam**
- `restart-warframe-steam.bat` - Перезапустить Warframe если WF скачан со Steam
- `restart-warframe-and-aleca-frame-steam.bat` - Перезапустить Warframe и AlecaFrame (Overwolf будет перезапущен!) если WF скачан со Steam

### **Батники для отдельного лаунчера**
- `restart-warframe-launcher.bat` - Перезапустить Warframe
- `restart-warframe-and-aleca-frame.bat` - Перезапустить Warframe и AlecaFrame (Overwolf будет перезапущен!)

### AlecaFrame
> [!warning]
> Укажите свой путь к Overwolf перед запуском этого файла!
> - `start-Aleca-Frame.bat` - Запустить AlecaFrame
- `kill-overwolf.bat` - Закрыть Overwolf

### Shutdown
- `kill-warframe-and-overwolf.bat` - Закрыть Warframe и Overwolf
- `kill-warframe.bat` - Закрыть Warframe

### Экспериментальные опции
- `warframe-cpu-priority.bat` - этот пакет отвечает за изменение приоритета процесса Warframe. Если данного пакета не будет в директории с пакетом перезапуска - функция не сработает.
  - Сначала он срабатывает когда видит запуск лаунчера (фальшстарт `Warframe.x64.exe`) и потом ждёт запуска Warframe как игры, чтобы задать ему приоритет процесса для CPU (на одну сессию). Пакет будет работать даже если вы запустите его отдельно, а потом запустите игру, или уже будете в игре. О параметрах и как включить - читайте ниже. Пожалуйста, протестируйте работу пакетов и [оставьте отзыв](https://github.com/N3M1X10/warframe-batch-tools/issues).


## Change CPU Priority on Launch
> [!caution]
> **Внимание! Опция для опытных пользователей!**
>
> **Используйте на свой страх и риск!**
>
> **Данный метод может повлиять на стабильность системы!**

> [!warning]
> **Экспериментальная функция**
> 
> Пожалуйста, протестируйте эту функцию и [оставьте отзыв](https://github.com/N3M1X10/warframe-batch-tools/issues)

Установить для процесса Warframe приоритет CPU, при каждом запуске игры через пакеты перезапуска этого репозитория.
- Для этого в пакете перезапуска (например `restart-warframe-launcher.bat`) - найдите переменную `change_priority` и установите `1`
```
set change_priority=1
```

- `warframe-cpu-priority.bat` - этот пакет отвечает за изменение приоритета процесса Warframe. Если данного пакета не будет в директории с пакетом перезапуска - функция не сработает.
  - Сначала он срабатывает когда видит запуск лаунчера (фальшстарт Warframe.x64.exe) и потом ждёт запуска Warframe как игры, чтобы задать ему приоритет процесса для CPU (на одну сессию). Пакет будет работать даже если вы запустите его отдельно, а потом запустите игру, или уже будете в игре. Пожалуйста, протестируйте работу пакетов и [оставьте отзыв](https://github.com/N3M1X10/warframe-batch-tools/issues).

Затем в `warframe-cpu-priority.bat` измените переменную `priority` на нужное вам значение
- Разрешённые значения: **`idle`, `low`, `BelowNormal`, `normal`, `AboveNormal`, `high`, `realtime`**

```
set priority=high
```
