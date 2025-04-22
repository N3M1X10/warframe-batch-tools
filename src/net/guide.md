### 📕guide.md
Другие страницы с инструкциями:
<p align="left">
   <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/warframe/guide.md">
      <img width="96" alt="warframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/warframe-badge.png">
   </a>
  <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/soulframe/guide.md">
      <img width="96" alt="soulframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/soulframe-badge.png">
   </a>
</p>

# 🔁Сброс настроек интернет адаптеров
### ⚠️Экспериментальная опция
Это может помочь, в случае проблем с подключением к лобби других игроков

>[!warning]
> - Требуется запустить пакет сброса адаптера для **всех** игроков, у кого наблюдается проблема!!!

- `net-restore.bat` - Сбросит IPV4 адатперы и очистит кэш-DNS
- `net-restore-extended.bat` - То же что и первый пакет, но с расширенными настройками сброса (используйте если не помогает первый пакет)

# 💬Починить чат в игре🗨️
> актуально на момент `22.04.2025`
1. Устанавливаем [**`AmnesiaWG`**](https://github.com/amnezia-vpn/amneziawg-windows-client/releases) и ставим в него файл конфигурации сгенерированный на [**`этом сайте`**](https://generator-warp.vercel.app)
2. В конфиге AmneziaWG, почти в самом низу, в разделе `[Peer]` - нужно изменить строку `AllowedIPs` значение: `172.232.25.131/32`

Пример:
```ini
[Peer]
PublicKey = {your_publickey}
AllowedIPs = 172.232.25.131/32
Endpoint = {your_endpoint}
```
- Ваши значения в `{` `}` скобках изменять не нужно!
