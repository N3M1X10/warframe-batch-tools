## 📕 readme.md

>[!tip]
> - Скачать репозиторий целиком: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)

## 💬 Починить чат в Warframe 🗨️

### Последовательность действий:
1. Качаем репозиторий и распаковываем в любую папку.
2. Прежде всего запускаем игру, это требуется для проверки IP, к которому игра пытается подключить ваш чат
3. Внутри папки репозитория, заходим в директорию: `src/net/warp-generator`
4. Запускаем **`start.bat`**

>[!caution]
> **ВНИМАНИЕ !!! НЕ ЗАКРЫВАЙТЕ ОКНО, ПОКА СКРИПТ НЕ НАПИШЕТ: `Press ENTER to close the window`**
>
> В противном случае скрипт не сработает и будут ошибки !

4.1. Появится окно **AmneziaWG**

5. В окне AmneziaWG внизу слева, нажимаем "**Добавить туннель**"
6. Заходим в директорию: `src/net/warp-generator/config`
7. Добавляем туннель **`WARP_warframe_chat.conf`**
8. Нажимаем "**Подключить**" в правой части окна AmneziaWG
9. Перезапускаем игру и проверяем чат ( может вступить в силу и без перезапуска, но придётся подождать )

### Альтернативный вариант, если не срабатывает `start.bat`
В случае если `start.bat` не генерирует конфиг, вам может помочь следующее:
1. Открываем и читаем [гайд по AmneziaWG](https://docs.google.com/document/d/1DX4X7t7V4QasQJYbps5D1yNtsK7tqsouSMJH2w4AMOY)
2. Устанавливаем [AmneziaWG](https://github.com/amnezia-vpn/amneziawg-windows-client) как написано в гайде и добавляем в него конфиг, сгенерированный на [**этом сайте**](https://generator-warp.vercel.app/)
3. Запускаем игру
4. Заходим в директорию: `src/net/warp-generator/portcheck` и запускаем там **`portcheck-warframe.bat`**
5. Открываем появившийся файл `warframe-connections.txt` и в нём смотрим столбец `RemoteAddress`
6. В конфиге AmneziaWG почти в самом низу, в разделе `[Peer]`, в строке "AllowedIPs" нужно вписать полученный в `warframe-connections.txt` IP-адрес
  - Пример: 
```ini
[Peer]
PublicKey = abracadabra
AllowedIPs = 172.232.25.131
Endpoint = engage.cloudflareclient.com:500
```
- Редактировать остальные значения не нужно!

## 📝 Примечания

- Проверено на работоспособность: `09.05.2025`
- Скрипт работает только на процессорах с архитектурой `amd64`
- Этот обход будет действовать преимущественно на ip чата и сайтов warframe. Что означает стабильную работу остальной игры
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
