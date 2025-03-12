# 🔁Быстрый перезапуск Warframe

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

## 📁Файлы

### **Батники для Steam**
- `restart-warframe-steam.bat` - Перезапустить Warframe если WF скачан со Steam
- `restart-warframe-and-aleca-frame-steam.bat` - Перезапустить Warframe и AlecaFrame (Overwolf будет перезапущен!) если WF скачан со Steam

### **Батники для отдельного лаунчера**
- `restart-warframe-launcher.bat` - Перезапустить Warframe
- `restart-warframe-and-aleca-frame.bat` - Перезапустить Warframe и AlecaFrame (Overwolf будет перезапущен!)

### 🔵AlecaFrame
> [!warning]
> Укажите свой путь к Overwolf перед запуском этого файла!
> - `start-Aleca-Frame.bat` - Запустить AlecaFrame
- `kill-overwolf.bat` - Закрыть Overwolf

### ❌Shutdown
- `kill-warframe-and-overwolf.bat` - Закрыть Warframe и Overwolf
- `kill-warframe.bat` - Закрыть Warframe

### ⚠️Экспериментальные опции
- `warframe-cpu-priority.bat` - этот пакет отвечает за изменение приоритета процесса Warframe. Если данного пакета не будет в директории с пакетом перезапуска - функция не сработает.

## ⚙️Change CPU Priority on Launch
Установить для процесса Warframe приоритет CPU, при каждом запуске игры через пакеты перезапуска этого репозитория.

> [!caution]
> **Внимание! Опция для опытных пользователей! Данный метод может повлиять на стабильность системы!**

> [!warning]
> **Экспериментальная функция**
> 
> Пожалуйста, протестируйте эту функцию и [оставьте отзыв](https://github.com/N3M1X10/warframe-batch-tools/issues)

1. Для включения опции, в пакете перезапуска (например `restart-warframe-launcher.bat`) - найдите переменную `change_priority` и установите `1`
```
set change_priority=1
```

2. Затем в `warframe-cpu-priority.bat` измените переменную `priority` на нужное вам значение

Разрешённые значения:

- `idle` - Cвободный
- `low` - Низкий
- `BelowNormal` - Ниже среднего
- `normal` - Обычный
- `AboveNormal` - Выше среднего
> [!caution]
> **ОСТОРОЖНО! ВОЗМОЖНО НАРУШЕНИЕ СТАБИЛЬНОСТИ СИСТЕМЫ!**
> - `high` - Высокий               
> - `realtime` - Реального времени

Пример:
```
set priority=high
```


## 🐞Известные ошибки
### Ошибки присвоение приоритета процесса
Учитывайте то, что если обновляете игру, или проверяете файлы клиента - потребуется повторный запуск пакета `warframe-cpu-priority.bat`. Это связано с тем, что этот пакет ждёт продолжительного присутствия `Warframe.x64.exe` и присваивает ему приоритет процесса. А обновление и прочие продолжительные функции в лаунчере - запускают `Warframe.x64.exe` на достаточный для сбоя в работе присвоения процесса для игры промежуток времени.

> [!important]
> На данный момент я в процессе размышлений и поиска решения. Если у вас есть решение проблем - буду очень рад увидеть ваш(-и) вариант(-ы)!
