## 📕 readme.md

>[!tip]
> - Скачать репозиторий целиком: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)

## 💬 Починить чат в Warframe 🗨️

### Последовательность действий:
1. Качаем репозиторий и распаковываем в любую папку.
2. Устанавливаем [AmneziaWG](https://github.com/amnezia-vpn/amneziawg-windows-client/releases) **AMD64**
2. Заходим на [**этот сайт**](https://generator-warp.vercel.app/) и генерируем конфиг для AmneziaWG (выберите свой тип подключения к сети: проводной, мобильный итд). Скачается файл с расширением `.conf`
3. В окне AmneziaWG внизу слева, нажимаем **`Добавить туннель`** и ищем скачанный конфиг файл
4. Запускаем игру, это требуется для проверки IP, к которому игра пытается подключить ваш чат
5. Внутри папки репозитория, заходим в директорию: `src/net/warp-generator/portcheck` и запускаем там **`portcheck-warframe.bat`**
6. Открываем появившийся файл `warframe-connections.txt` и в нём смотрим столбец `RemoteAddress`
7. В конфиге AmneziaWG почти в самом низу, в разделе `[Peer]`, в строке `AllowedIPs` нужно вписать полученный в `warframe-connections.txt` IP-адрес

>[!tip]
>- Пример:
>```ini
>[Peer]
>PublicKey = abracadabra
>AllowedIPs = 172.232.25.131
>Endpoint = engage.cloudflareclient.com:500
>```
>- Редактировать остальные значения не нужно!

8. Сохраняем конфигурацию и нажимаем **`Подключить`** в правой части окна AmneziaWG
9. Перезапускаем игру и проверяем чат ( может вступить в силу и без перезапуска, но придётся подождать )


## 📝 Примечания

- Проверено на работоспособность: `09.05.2025`
- Скрипт работает только на процессорах с архитектурой `amd64`
- Этот обход будет действовать преимущественно на ip чата и сайтов warframe. Что означает штатную работу остальной сетевой части игры
- При использовании AmneziaWG - требуется отключить любые VPN или прокси (Для обхода других ресурсов, можно использовать - [Flowseal/zapret](https://github.com/Flowseal/zapret-discord-youtube))

>[!caution]
> - Пользовательское соглашение (End User License Agreement) не одобряет подобного рода обходов. Это крайняя мера
>   - Ответ команды поддержки Warframe:
>```txt
>Thank you for contacting us.
> 
>We appreciate you reaching out to clarify this.
>Please note that while using general VPN services to improve connection stability is allowed, modifying or redirecting Warframe’s network traffic — including through third-party tools >like AmneziaWG or similar methods — is not permitted under our Terms of Use and End User License Agreement (EULA).
> 
>Using such tools, even if intended only for specific services like in-game chat, is considered tampering with Warframe's services and can lead to account penalties, including >suspension or banning.
> 
>We strongly recommend avoiding the use of any third-party applications that alter or redirect Warframe’s network traffic to ensure the security of your account.
> 
>Thank you for your understanding, and let us know if you have any other questions!
> 
>Kind regards,
>Warframe Support Team
>```

- Раньше тут была попытка сделать скрипт автоматической настройки конфигурации awg, но его поддержание и отладка была - брошена, а - скрипт удалён.
  - Но всё ещё можно настраивать всё вручную (и это гораздо надёжнее)
