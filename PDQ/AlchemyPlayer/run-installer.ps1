$filepath = "C:\temp\AlchemyPlayerSetup\AlchemyPlayerSetup\Installer\DISK1\"

set-location -Path $filepath

msiexec.exe /qb /i "Alchemy Player.msi" TRANSFORMS=1033.MST