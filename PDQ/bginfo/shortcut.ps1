New-Item –ItemType Directory –Force –Path "C:\Program Files\BGInfo" | Out-Null 

Copy-Item –Path "$PSScriptRoot\Bginfo64.exe" –Destination "C:\Program Files\BGInfo\BGInfo64.exe" 

Copy-Item –Path "$PSScriptRoot\Workstations.bgi" –Destination "C:\Program Files\BGInfo<custom>.bgi"
$Shell = New-Object –ComObject ("WScript.Shell") 
$ShortCut = $Shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\BGInfo.lnk") 
$ShortCut.TargetPath=""C:\Program Files\BGInfo\BGInfo64.exe""

$ShortCut.Arguments = ""C:\Program Files\BGInfo\<custom>.bgi" /timer:0 /silent /nolicprompt" 
$ShortCut.IconLocation = "BGInfo64.exe, 0" 
$ShortCut.Save()