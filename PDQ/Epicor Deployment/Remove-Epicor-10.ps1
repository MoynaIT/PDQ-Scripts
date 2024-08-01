$DesktopPath = 'C:\Users\Public\Desktop\Epicor Software\Epicor ERP 10.2 Client'

$InstallPath = 'C:\Epicor\ERP10.2Client'

if (test-path -path $DesktopPath) {
    Remove-Item -Path $DesktopPath -Recurse -Force -Confirm:$false
}else {
    continue
}

if (test-path -path $InstallPath) {
    Remove-Item -Path $InstallPath -Recurse -Force -Confirm:$false
}else {
    continue
}
