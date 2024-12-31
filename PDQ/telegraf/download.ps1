set-location "C:\temp"

wget "https://dl.influxdata.com/telegraf/releases/telegraf-1.33.0_windows_amd64.zip" -UseBasicParsing -OutFile telegraf-1.33.0_windows_amd64.zip

Expand-Archive .\telegraf-1.33.0_windows_amd64.zip -DestinationPath ".\telegraf"

New-Item -ItemType Directory -Path "C:\Program Files\Telegraf"

mv ".\telegraf\telegraf-1.33.0\telegraf.exe" "C:\Program Files\Telegraf\telegraf.exe" 