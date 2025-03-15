# 🔁Быстрый перезапуск Warframe

## Перезапуск для Steam версии (запуск без вызова Steam)

>[!tip]
> - Чтобы скачать файлы: [Ищем такую кнопку](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). А за подробностями [Сюда](https://docs.github.com/ru/get-started/start-your-journey/downloading-files-from-github) или [Сюда](https://blog.skillfactory.ru/kak-skachivat-s-github/)
> - Для редактирования скачанного на вашем ПК файла: **`ПКМ` -> `Изменить`**


> [!warning]
> Укажите **свой** путь к Warframe перед запуском этих файлов!
>
> Пример:
> ```
> set warframe=C:\Program Files (x86)\Steam\steamapps\common\Warframe
> ```

> [!tip]
> ### Если вам требуется запускать Warframe через Steam
>```
>set without_steam=0
>```

## 📁Файлы

### **Батники для Steam**
- [**`restart-warframe-steam.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/n3m1x10/warframe/restart-warframe-steam.bat) - Перезапустить только Warframe

### **Батники для отдельного лаунчера**
- [**`restart-warframe-launcher.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/n3m1x10/warframe/restart-warframe-launcher.bat) - Перезапустить Warframe

### 🔵AlecaFrame
> [!warning]
> Укажите свой путь к Overwolf перед запуском этого файла!
> Пример:
> ```
> set overwolf=C:\Program Files\overwolf
> ```
> - [**`start-Aleca-Frame.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/n3m1x10/warframe/aleca-frame/start-Aleca-Frame.bat) - Запустить AlecaFrame
- [**`kill-overwolf.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/n3m1x10/warframe/aleca-frame/kill-overwolf.bat) - Закрыть Overwolf

### ❌Shutdown
- [**`kill-warframe-and-overwolf.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/n3m1x10/warframe/kill/kill-warframe-and-overwolf.bat) - Закрыть Warframe и Overwolf
- [**`kill-warframe.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/n3m1x10/warframe/kill/kill-warframe.bat) - Завершить процесс `Warframe.x64.exe`

### ⚠️Экспериментальные опции
- [**`warframe-cpu-priority.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/n3m1x10/warframe/warframe-cpu-priority.bat) - этот пакет отвечает за изменение приоритета процесса Warframe. Если данного пакета не будет в директории с пакетом перезапуска - функция не сработает.

## ⚙️Change CPU Priority on Launch
Установить для процесса Warframe приоритет CPU, при каждом запуске игры через пакеты перезапуска этого репозитория.

> [!caution]
> **Внимание! Опция для опытных пользователей! Данный метод может повлиять на стабильность системы!**

> [!warning]
> **Экспериментальная функция**
> 
> Пожалуйста, протестируйте эту функцию и [**оставьте отзыв**](https://github.com/N3M1X10/warframe-batch-tools/issues)

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
