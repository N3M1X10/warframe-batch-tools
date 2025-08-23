### 📕readme-en.md
> [readme-ru](https://github.com/N3M1X10/warframe-batch-tools/blob/master/src/quick-restart/readme.md)

>[!caution]
> Here is a quick AI-translate. It may contain mistakes

# 🔁Quick Restart for Warframe or Soulframe

**Tip**

- Download the entire repository: [**`Download ZIP`**](https://github.com/N3M1X10/warframe-batch-tools/archive/refs/heads/master.zip)
- Download from releases: [**`Releases`**](https://github.com/N3M1X10/warframe-batch-tools/releases)
- To download individual files: [Look for this button](https://github.com/user-attachments/assets/c0169211-4266-4d54-b594-22e762d0938b). For details, see [here](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) or [here](https://blog.skillfactory.ru/kak-skachivat-s-github/)

---

## Important Notes on Parameters

**Tip**

### Briefly About Variables

Inside the scripts, there are variables (i.e., settings and options):

> A variable block looks like this:
>
> ```
> :: description
> set name=value
> ```
>
> - `set` — variable assignment command
> - `name` — variable name
> - `value` — variable value
> - `description` — comment describing the variable

- By editing them, you can configure the script's behavior during restart.
- To edit a downloaded batch script on your PC: **`Right-click` → `Edit`**
- Pay close attention to variable examples to avoid script errors.

**Warning**

### If You Want to Launch the Game via Steam

You need to set the following variable:

```batch
set launch_type=steam
```

**Tip**

### Launching the Game Without Waking Up Steam

If you want Warframe to launch without waking up Steam (launch the game launcher separately):

The variable should look like this:

```batch
set without_waking_up_steam=1
```

> Before using this option, make sure to set `set launch_type=steam` and specify **your** path to Warframe before running the script!
>
> Example path:
>
> ```batch
> set steam_warframe_path=C:\Program Files (x86)\Steam\steamapps\common\Warframe
> ```
>
> Otherwise, the script will not be able to apply silent launch parameters. It will try to launch the game via a separate launcher in localappdata, and if it is not found, it will throw an error.

**Note**

Other variables and their descriptions are inside the script itself (possibly, I will describe them here later).

---

## 📁Files

- **`restart-warframe-united.bat`** — Batch script for restarting Warframe with various additions (functions)
- **`restart-soulframe-united.bat`** — Same batch script for restarting Soulframe
- **`bin`** folder — collection of additional scripts for the main restart script and other utilities. Read more below.

### ⚠️Additional Restart Options

- **`bin\powershell\cpu-priority\cpu-priority.ps1`** — Powershell script responsible for changing the process priority of the selected game.
  - If this batch file is missing in the directory, the function will not work.
  - You can always specify your path to this script inside the restart batch scripts, as well as inside the manual launch scripts.
  - **`bin\powershell\cpu-priority\apply-warframe-cpu-priority.bat`** — Batch script for manual launch of the Powershell script with Warframe parameters
  - **`bin\powershell\cpu-priority\apply-soulframe-cpu-priority.bat`** — Batch script for manual launch of the Powershell script with Soulframe parameters

**Warning**

Experimental feature. Additional testing required.

> - **`src\quick-restart\bin\powershell\autorestart\autorestart-scrobbler.ps1`** — Powershell script for auto-restart with Warframe parameters
> - **`src\quick-restart\bin\powershell\autorestart\autorestart-scrobbler.bat`** — Batch script for manual launch with Warframe parameters

This script has logging enabled. A log file will be created in its directory.
Since this is an experimental feature, I see no reason to disable logging.
This will make it easier to find errors.

### 🔵AlecaFrame

**Warning**

- **`start-Aleca-Frame.bat`** — Launch AlecaFrame

> Specify your path to Overwolf before running this file!
> Example:
>
> ```batch
> set overwolf=C:\Program Files\overwolf
> ```

- **`kill-overwolf.bat`** — Close Overwolf

### ❌Shutdown

- **`bin\kill\kill-warframe-and-overwolf.bat`** — Close Warframe and Overwolf
- **`bin\kill\kill-warframe.bat`** — Close Warframe along with the launcher
- **`bin\kill\kill-soulframe.bat`** — Close Soulframe along with the launcher

---

## 🤖♻Automatic Game Restart on Host Migration

**Note**

### What is this?

The repository contains a script that, when launched, will continuously scan the game log in the background for host migration messages.
As soon as it detects one, it will immediately restart the game via the batch file.

> No need to worry about CPU usage: Powershell does this very gently and practically does not load the processor with this scanning.
> The script still monitors the game. If the game (and launcher) suddenly disappears, it will close itself.

**Tip**

### How to Enable?

1. To enable the option, in the restart script (e.g., `restart-warframe-united.bat`), right-click → Edit → find the `autorestart_scrobbler` variable and set it to `1`.

> Example:
>
> ```batch
> set autorestart_scrobbler=1
> ```

**Note**

### Why is this needed?

Host migration often happens for various reasons when you don't want it to.
For example, when you go on a long mission with friends, gather in a tightly-knit **squad**, and start farming.
Suddenly, you experience a host migration, while everyone else remains in place.
In such cases, an experienced player quickly opens Task Manager and manually closes the game.
The faster you do this, the higher the chance that the game will try to reconnect you to the **squad**. You just need to wait a bit after logging back in.
This script will restart the game for you automatically. Just launch the game via the restart batch file with the option enabled.
This way, it can save you from losing precious resources :)

**Tip**

> The script supports several in-game commands, but only from the player invitation menu:
>
> - `_stop-ars` or `_cancel-ars` — Stop the entire scrobbler script
> - `_reboot` or `_restart` — Restart the game
>
> Important notes on usage:
>
> - Enter the command > Click "Invite" > Close the invitation window and wait a couple of seconds > Open the window again.
> - The game will then show the key message in the log, and the script will detect it.
> - The game log updates this information not immediately, but after some time or when you reopen this menu. Delays are possible.
> - Use this as a last resort. If possible, exit the game manually.

---

## ⚙️Changing Process Priority on Launch

You can set the CPU priority for the Warframe process every time you launch the game via the restart batch script from this repository.

**Caution**

**Attention! This option is for advanced users! This method may affect system stability!**

### How to Enable and Configure?

1. To enable the option, in the restart script (e.g., `restart-warframe-united.bat`), right-click → Edit → find the `change_priority` variable and set it to `1`.

**Note**

Example:

```batch
set change_priority=1
```

2. Then, in the restart script (e.g., `restart-warframe-united.bat`), right-click → Edit → change the value of the `priority` variable to your desired setting.

**Tip**

Allowed values:

- `low` — Low
- `BelowNormal` — Below Normal
- `normal` — Normal
- `AboveNormal` — Above Normal
- `high` — High
- `realtime` — Realtime

**Note**

Example:

```batch
set priority=high
```

### How Does This Work?

- When you run the game restart batch file, it launches a Powershell script (`bin\warframe-cpu-priority.ps1`), which in the background monitors the game window launch. As soon as it detects the game window, it applies the process priority you specified in the Powershell script settings.
- If you do not log into the game and close the launcher, the script will terminate itself in the background.

**Tip**

- If you close the launcher window, the script will stop executing. To run the function again, you will need to restart either via the restart batch file or directly via the Powershell script in the corresponding folder.

---

## 💻User Account Control

To disable system protection notifications when running repository files, see:

- [**`windows-batch/src/net/uac`**](https://github.com/N3M1X10/windows-batch/tree/master/src/system-policies/uac)

This will simplify and speed up working with the repository scripts.
