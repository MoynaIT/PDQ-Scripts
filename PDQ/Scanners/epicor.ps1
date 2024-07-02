$Folder = 'C:\Epicor'
$epicor10path= 'C:\Epicor\ERP10*'
$epicor11path = 'C:\Epicor\ERP11*'

if (Test-Path -Path $Folder) {
    $epicor = "installed"
    if (Test-Path -Path $epicor10path) {$epicor10 = "installed"}
    if (Test-Path -Path $epicor11path) {$epicor11 = "installed"}

    [PSCustomObject]@{
        Epicor = $epicor
        Epicor10 = $epicor10
        Epicor11 = $epicor11
        }
} else {
    [PSCustomObject]@{
        Epicor = "missing"
        Epicor10 = $null
        Epicor11 = $null
        }
}