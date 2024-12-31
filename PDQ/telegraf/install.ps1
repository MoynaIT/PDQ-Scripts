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