$DesktopPath = 'C:\Users\Public\Desktop\Epicor Software\Epicor ERP 10.2 Client'

$InstallPath = 'C:\Epicor\ERP10.2Client'

Remove-Item -Path $DesktopPath -Recurse -Force -Confirm:$false

Remove-Item -Path $InstallPath -Recurse -Force -Confirm:$false