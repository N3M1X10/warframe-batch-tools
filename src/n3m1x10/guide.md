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

## Warframe High CPU Priority
> [!caution]
> **Внимание! Опция для опытных пользователей!**
>
> **Используйте на свой страх и риск!**
>
> **Данный метод может повлиять на стабильность системы в целом**

Установить высокий приоритет CPU по умолчанию, при каждом запуске приложения
- `Warframe.x64.exe-high-CPU-priority.reg` - запустите чтобы установить ключ реестра, для установления высокого приоритета - по умолчанию
- `remove-cpu-priority.bat` - запустите чтобы удалить приоритет CPU для Warframe из реестра

# \aleca-frame\
> [!warning]
> Укажите свой путь к Overwolf перед запуском этого файла!
> - `start-Aleca-Frame.bat` - Запустить AlecaFrame

- `kill-overwolf.bat` - Закрыть Overwolf
