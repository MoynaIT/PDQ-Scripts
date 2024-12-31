set-location "C:\temp"

wget "https://dl.influxdata.com/telegraf/releases/telegraf-1.33.0_windows_amd64.zip" -UseBasicParsing -OutFile telegraf-1.33.0_windows_amd64.zip

Expand-Archive .\telegraf-1.33.0_windows_amd64.zip -DestinationPath ".\telegraf"

New-Item -ItemType Directory -Path "C:\Program Files\telegraf"

Move-Item -Path ".\telegraf\telegraf-1.33.0\telegraf.exe" -Destination "C:\Program Files\telegraf\telegraf.exe" 

$path = "C:\Program Files\telegraf\conf\"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

# Victoria Metrics Settings
$victoria_url = (bws.exe secret get c02559c0-e6da-4914-934c-b257013c2a8d | convertfrom-Json).value
$victoria_database = "windows"

# env registry key
$telegraf_env =("victoria_url=$victoria_url","victoria_database=$victoria_database")

# Create registry entries for telegraf
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\telegraf"-Name "Environment" -PropertyType MultiString -Value $telegraf_env -Force

# Create and start telegraf service
if (!(Get-Service telegraf)) {
      & 'C:\Program Files\telegraf\telegraf.exe' --service install --config-directory 'C:\Program Files\telegraf\telegraf.d'
  }
  
Set-Service -Name telegraf -Status Running -StartupType Automatic
Restart-Service telegraf