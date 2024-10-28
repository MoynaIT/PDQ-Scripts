# this script calls an N8N webhook with a little bit of data from meshagent.exe
# the N8N function the calls the Hudu API and updates the asset with the link.

# todo:
# - figure out how to secure it without having the key in the code. Honestly there isn't much of a risk here,
#   but it's a concern.

#if (Get-Module -ListAvailable -Name HuduAPI) {
#    Import-Module SecretManagement.KeePass 
#}
#else {
#    Install-Module -name SecretManagement.KeePass -RequiredVersion 0.9.2 -Force -confirm:$true
#    Import-Module SecretManagement.KeePass
#}

$meshAgent = "C:\Program Files\Mesh Agent\MeshAgent.exe"
$meshParms = "-nodeid"
$meshURL = (bws.exe secret get 87a6bf1c-3259-4b1a-844e-b21700e79c9e | convertfrom-Json).value
$n8nURL = (bws.exe secret get 2f62489a-31a3-4e31-a088-b21700e75610 | convertfrom-Json).value
$n8nToken = (bws.exe secret get d8facf10-af46-40bc-a12c-b21700e78148 | convertfrom-Json).value
$headers = @{'authorization' = "Bearer $n8nToken" }

# Asset Name
$assetName = $ENV:COMPUTERNAME

# grab the Meshcentral ID from the agent.exe
$meshNodeID = & "$meshAgent" $meshParms
$meshFullURL = $meshURL + $meshNodeID

$AssetFields = @{
    "name" = $assetName
    "meshagent" = "$meshFullURL"
}

$request = Invoke-WebRequest -Uri $n8nURL -Headers $headers -Method POST -Body $AssetFields