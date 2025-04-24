### 📕readme.md
<p align="left">
   <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/warframe/readme.md">
      <img width="96" alt="warframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/warframe-badge.png">
   </a>
  <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/soulframe/readme.md">
      <img width="96" alt="soulframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/soulframe-badge-hl.png">
   </a>
</p>

# 🔁Быстрый перезапуск Soulframe

>[!tip]
> - Скачать репозиторий целиком: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)
> - Чтобы скачать отдельные файлы: [Ищем такую кнопку](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). А за подробностями [Сюда](https://docs.github.com/ru/get-started/start-your-journey/downloading-files-from-github) или [Сюда](https://blog.skillfactory.ru/kak-skachivat-s-github/)
> - Для редактирования скачанного на вашем ПК bat-файла: **`ПКМ` -> `Изменить`**

- **`restart-soulframe-launcher.bat`** - Быстрый перезапуск для Soulframe
- **`bin\kill\kill-soulframe.bat`** - Закрыть Soulframe вместе с лаунчером

### ⚠️Экспериментальные опции
- **`bin\soulframe-cpu-priority.ps1`** - это powershell скрипт, который отвечает за изменение приоритета процесса Soulframe. Если данного файла не будет в директории - функция не сработает
- **`bin\apply-soulframe-cpu-priority.bat`** - пакет для ручного запуска powershell скрипта

## ⚙️Изменение приоритета процесса при запуске
Установить для процесса Soulframe приоритет CPU, при каждом запуске игры через пакетные-файлы перезапуска этого репозитория

> [!caution]
> **Внимание! Опция для опытных пользователей! Данный метод может повлиять на стабильность системы!**

1. Для включения опции, в пакетном файле перезапуска (`restart-soulframe-launcher.bat`) -> пкм -> изменить -> найдите переменную `change_priority` и установите `1`

```bat
set change_priority=1
```

2. Затем в `bin\soulframe-cpu-priority.ps1` -> пкм - изменить -> поменяйте значение переменной `$Priority` на нужное вам

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

## 💻User Account Control
Для отключения уведомлений системы защиты при запуске файлов репозитория можно обратиться сюда:
- [**`src/uac/readme.md`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/uac/readme.md)