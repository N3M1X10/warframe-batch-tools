## 📕readme.md

>[!tip]
> - Скачать репозиторий целиком: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)

## 💬Починить чат в игре🗨️
>[!note]
> актуально на момент `28.04.2025`

Последовательность действий:
1. Прежде всего запускаем игру, это требуется для проверки IP, к которому игра пытается подключить ваш чат
2. Внутри папки репозитория, заходим в директорию: `src/net/warp-generator`
3. Запускаем **`start.bat`**. Появится окно **AmneziaWG**
4. В окне AmnesiaWG внизу слева, нажимаем "Добавить туннель"
5. Заходим в директорию: `src/net/warp-generator/bin`
6. Добавляем туннель **`WARP_warframe_chat.conf`**
7. Нажимаем "Подключить" в правой части окна AmnesiaWG
8. Перезапускаем игру и проверяем чат

### Альтернативный вариант, если не срабатывает `start.bat`
В случае если `start.bat` не генерирует конфиг, вам может помочь следующее:
1. Открываем и читаем [гайд по AmneziaWG](https://docs.google.com/document/d/1DX4X7t7V4QasQJYbps5D1yNtsK7tqsouSMJH2w4AMOY)
2. Устанавливаем awg как написано в гайде и добавляем в него конфиг, сгенерированный на [**этом сайте**](https://generator-warp.vercel.app/)
3. Заходим в директорию: `src/net/warp-generator/portcheck` и запускаем там **`portcheck-warframe.bat`**
4. Открываем появившийся файл `connections.txt` и в нём смотрим столбец `RemoteAddress`
5. В конфиге AmneziaWG почти в самом низу, в разделе `[Peer]`, в строке "AllowedIPs" нужно вписать полученный в `connections.txt` IP-адрес
  - Пример: 
```ini
[Peer]
PublicKey = abracadabra
AllowedIPs = 172.232.25.131
Endpoint = engage.cloudflareclient.com:500
```
- Редактировать остальные значения не нужно!

## Примечания
- Этот конфиг будет действовать преимущественно на ip чата и сайтов warframe. Что означает стабильную работу остальной игры

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
