# Что за что отвечает

## Отдельный лаунчер Warframe
- `restart-warframe-launcher.bat` - Перезапустить Warframe
- `restart-warframe-and-aleca-frame.bat` - Перезапустить Warframe и AlecaFrame (Overwolf будет перезапущен!)

## Steam (запуск без вызова steam)
> [!warning]
> ### Укажите **свой** путь к Warframe перед запуском этих файлов!
>
> ### Примеры:
> 
> Warframe
> ```
> :: Set the Warframe directory path !!! (without quotes)
> set warframe=C:\Program Files (x86)\Steam\steamapps\common\Warframe
> ```
>
> Overwolf
> ```
> set overwolf=C:\Program Files\overwolf
> ```
> 
> - `restart-warframe-steam.bat` - Перезапустить Warframe если WF скачан со Steam
> - `restart-warframe-and-aleca-frame-steam.bat` - Перезапустить Warframe и AlecaFrame (Overwolf будет перезапущен!) если WF скачан со Steam

## Shutdown
- `kill-warframe-and-overwolf.bat` - Закрыть Warframe и Overwolf
- `kill-warframe.bat` - Закрыть Warframe

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
> Пожалуйста, протестируйте эту функцию и оставьте отзыв

Установить приоритет CPU по умолчанию, при каждом запуске приложения
- Для этого в пакете перезапуска (например `restart-warframe-launcher.bat`) - установите `1` у переменной `change_priority`

```
:: Change CPU Priority on Launch [1 / 0] (read guide.md)
:: WARNING! UNSTABLE!
:: PLEASE, TEST THIS FEATURE AND LEAVE A REVIEW
set change_priority=1
```

- `warframe-cpu-priority.bat` - этот пакет отвечает за изменение приоритета процесса Warframe

Затем в `warframe-cpu-priority.bat` измените переменную `priority` на нужное вам значение
- Разрешённые значения: `idle`, `low`, `BelowNormal`, `normal`, `AboveNormal`, `high`, `realtime`

```
::# OPTIONS
:: ## Change CPU Priority on Launch
:: - Possible values: "idle", "low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"
:: - Default: normal
set priority=high
```


# \aleca-frame\
> [!warning]
> Укажите свой путь к Overwolf перед запуском этого файла!
> - `start-Aleca-Frame.bat` - Запустить AlecaFrame

- `kill-overwolf.bat` - Закрыть Overwolf
