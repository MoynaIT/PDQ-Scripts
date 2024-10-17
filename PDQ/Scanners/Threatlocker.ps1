$threatlockerExe = "C:\Program Files\ThreatLocker\"

if (Test-Path -Path $threatlockerExe) {
    $threatLocker = "installed"
    [PSCustomObject]@{
        ThreatLocker = $threatLocker
        }
} else {
    [PSCustomObject]@{
        ThreatLocker = "missing"
        }
}