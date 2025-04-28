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
- Этот конфиг будет действовать только на ip чата. Что означает стабильную работу всего остального (без проксирования)
