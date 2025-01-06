$zippath = 'C:\temp\AlchemyPlayerSetup.zip'
$folder = 'C:\temp\AlchemyPlayerSetup'

Remove-Item -Path $zippath -Force -Confirm:$false
Remove-Item -Path $folder -Recurse -Force -Confirm:$false