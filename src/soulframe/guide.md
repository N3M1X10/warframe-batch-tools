### 📕guide.md
<p align="left">
   <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/warframe/guide.md">
      <img width="96" alt="warframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/warframe-badge.png">
   </a>
  <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/soulframe/guide.md">
      <img width="96" alt="soulframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/soulframe-badge-hl.png">
   </a>
</p>

# Soulframe batch files
- [**`restart-soulframe-launcher.bat`**](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/soulframe/restart-soulframe-launcher.bat) - Быстрый перезапуск для Soulframe

## ⚙️Change CPU Priority on Launch
Установить для процесса Warframe приоритет CPU, при каждом запуске игры через пакеты перезапуска этого репозитория

> [!caution]
> **Внимание! Опция для опытных пользователей! Данный метод может повлиять на стабильность системы!**

1. Для включения опции, в пакете перезапуска (`restart-soulframe-launcher.bat`) - найдите переменную `change_priority` и установите `1`
```bat
set change_priority=1
```

2. Затем в `soulframe-cpu-priority.ps1` измените переменную `$Priority` на нужное вам значение

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
