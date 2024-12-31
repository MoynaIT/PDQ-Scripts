# Create and start telegraf service
if (!(Get-Service telegraf)) {
    & 'C:\Program Files\telegraf\telegraf.exe' --service install --config-directory 'C:\Program Files\telegraf\telegraf.d'
}

Set-Service -Name telegraf -Status Running -StartupType Automatic
Restart-Service telegraf