# 📕guide.md

>[!tip]
> - Скачать репозиторий целиком: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)
> - Чтобы скачать отдельные файлы: [Ищем такую кнопку](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). А за подробностями [Сюда](https://docs.github.com/ru/get-started/start-your-journey/downloading-files-from-github) или [Сюда](https://blog.skillfactory.ru/kak-skachivat-s-github/)
> - Для редактирования скачанного на вашем ПК bat-файла: **`ПКМ` -> `Изменить`**


## 💬Починить чат в игре🗨️
>[!note]
> актуально на момент `24.04.2025`

Последовательность действий:
1. Прежде всего запускаем игру, это требуется для проверки IP, к которому игра пытается подключить ваш чат
2. Внутри папки репозитория, заходим в директорию: `src/net/warp-generator`
3. Запускаем **`start.bat`**. Появится окно **AmneziaWG**
4. В окне AmnesiaWG внизу слева, нажимаем "Добавить туннель"
5. Заходим в директорию: `src/net/warp-generator/bin`
6. Добавляем туннель **`WARP_warframe_chat.conf`**
7. Нажимаем "Подключить" в правой части окна AmnesiaWG
8. Перезапускаем игру и проверяем чат

### Альтернативный вариант, если не помогает
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



## 🔁Сброс настроек интернет адаптеров
### ⚠️Экспериментальная опция
Это может помочь, в случае проблем с подключением к лобби других игроков

>[!warning]
> - Требуется запустить пакет сброса адаптера для **всех** игроков, у кого наблюдается проблема!!!

- `net-restore.bat` - Сбросит IPV4 адатперы и очистит кэш-DNS
- `net-restore-extended.bat` - То же что и первый пакет, но с расширенными настройками сброса (используйте если не помогает первый пакет)

>[!tip]
>Загляните на другие страницы:
>
> > Быстрый перезапуск игры
> ><p align="left">
> >   <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/warframe/guide.md">
> >      <img width="96" alt="warframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/warframe-badge.png">
> >   </a>
> >  <a href="https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/soulframe/guide.md">
> >      <img width="96" alt="soulframe guide" src="https://github.com/N3M1X10/warframe-batch-tools/blob/master/assets/soulframe-badge.png">
> >   </a>
> ></p>
