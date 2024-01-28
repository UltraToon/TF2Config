$ErrorActionPreference = 'stop'
$TF2 = "C:\Program Files (x86)\Steam\steamapps\common\Team Fortress 2"
if (!(Test-Path $TF2)) {"[ERROR] TF2 not found! Please install it!"}
Clear-Host
do {
    $mainOptions = Read-Host -prompt "
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~       ____             __ _         _____    _ _ _                  ~
    ~      / ___|___  _ __  / _(_) __ _  | ____|__| (_) |_ ___  _ __      ~
    ~     | |   / _ \| '_ \| |_| |/ _` | |  _| / _` | | __/ _ \| '__|     ~
    ~     | |__| (_) | | | |  _| | (_| | | |__| (_| | | || (_) | |        ~
    ~      \____\___/|_| |_|_| |_|\__, | |_____\__,_|_|\__\___/|_|        ~
    ~                             |___/                                   ~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Manage:
        [1] Manage Presets [custom]
        [2] Manage Bases [cfg] (NOT SETUP YET DO NOT CHOOSE)

    Other:
        [3] What is this?
        [4] Reset TF2
    "
} until ($mainOptions -in 1..4)
Clear-Host
if ($mainOptions -eq 1) {
    $presetMenu = "
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ~      ____                     _     __  __                                        ~
    ~     |  _ \ _ __ ___  ___  ___| |_  |  \/  | __ _ _ __   __ _  __ _  ___ _ __      ~
    ~     | |_) | '__/ _ \/ __|/ _ \ __| | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__|     ~
    ~     |  __/| | |  __/\__ \  __/ |_  | |  | | (_| | | | | (_| | (_| |  __/ |        ~
    ~     |_|   |_|  \___||___/\___|\__| |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|        ~
    ~                                                              |___/                ~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    Manage:
        [1] Upload a preset

    Select:
        {0} 

    "
    if (!(Test-Path ".\TF2CE_Presets.cfg")) {$null = New-Item ".\TF2CE_Presets.cfg" -Force}
    $map = @{}; $counter = 2
    $addToMenu = Get-Content 'TF2CE_Presets.cfg' | ForEach-Object {
        $leaf = Split-Path $_ -Leaf
        $map[$counter.ToString()] = "$_"
        '[{0}] {1}' -f $counter++, $leaf
    }
    $selection = Read-Host ($presetMenu -f ($addToMenu -join [System.Environment]::NewLine))
    if ($selection -eq 1) {
        Add-Type -AssemblyName System.Windows.Forms
        $folderDialog = [System.Windows.Forms.FolderBrowserDialog]::new()
        $dialogResult = $folderDialog.ShowDialog()
        if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
            Add-Content '.\TF2CE_Presets.cfg' -Value $folderDialog.SelectedPath
        } else {Write-Error "User chose Cancel"}
    } elseif ($selection -ge 2) {
        'Cleaning up...'
        Remove-Item "$TF2\tf\custom" -Force -Recurse -ErrorAction SilentlyContinue
        'Applying preset...'
        Copy-Item $map[$selection] "$TF2\tf\custom" -Recurse -Force
        }
} elseif ($mainOptions -eq 3) {
    $null = Read-Host -prompt '
    > [Presets]
        1. They are basically duplicates of your [tf/custom] folder (huds, mods, cfg, sounds etc.,)
        2. You can swap them out whenever you want, without having to reset everything or move files around.
        3. They can be anywhere on your PC, just load them in. It does it for you after that.
        4. Just open the Preset Manager, choose "[1] Upload a preset", then reload the script. It should be there now.
    
    > [Bases]
        1. Just like presets, but with your CFG folders, I decided to do this seperately for modularity reasons.
        2. Lets say you have a friend over, with different settings, all you have to do is "[1] Upload a base", reload, then choose it!
    
    > [Reset TF2]
        1. Hence the name, it resets TF2 of its configuration and files. This does not modify account data since its saved in the cloud.
        2. Its useful to fix your game if its broken in a way, or have a fresh new start to make a config.
        3. If you have things you care about in the TF folder, then back them up to another location outside of the game folder.
    
    [ENTER] Exit
        '
} elseif ($mainOptions -eq 4) {
    $null = Read-Host -prompt '
    !!! PLEASE BACKUP YOUR CFG AND CUSTOM FOLDER IF YOU WANT TO KEEP SETTINGS !!!
    > It will NOT reset account data (LVLS, ITEMS, ETC.,)

        [ENTER] Continue
        [CTRL+C] Cancel
    '
    Clear-Host
    Remove-Item "$TF2\tf\custom\*", "$TF2\tf\cfgs" -Recurse -Force -ErrorAction SilentlyContinue
    Get-ChildItem "C:\Program Files (x86)\Steam\userdata\*\440\remote\cfg\config.cfg" | Set-content -Value $null
    Start-Process steam://validate/440
    "Doing a file validation check! It should show the [PLAY] button once finished."
    $null = Read-Host -prompt "Press [ENTER] when the process is done"
    Start-Process -filepath "$TF2\hl2.exe" -argumentlist "-novid -autoconfig -default +host_writeconfig config.cfg full +mat_savechanges +quit -game tf" -wait
}

Clear-Host
"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~                                                   ~
~      ____  _   _  ____ ____ _____ ____ ____       ~
~     / ___|| | | |/ ___/ ___| ____/ ___/ ___|      ~
~     \___ \| | | | |  | |   |  _| \___ \___ \      ~
~      ___) | |_| | |__| |___| |___ ___) |__) |     ~
~     |____/ \___/ \____\____|_____|____/____/      ~
~                                                   ~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[ Press ENTER to exit ]                                       
"
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null