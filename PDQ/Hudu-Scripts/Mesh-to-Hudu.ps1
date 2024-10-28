# this script calls an N8N webhook with a little bit of data from meshagent.exe
# the N8N function the calls the Hudu API and updates the asset with the link.

$meshAgent = "C:\Program Files\Mesh Agent\MeshAgent.exe"
$meshParms = "-nodeid"
$meshURL = (bws.exe secret get 87a6bf1c-3259-4b1a-844e-b21700e79c9e -t 0.2530736b-47f1-4d7d-9a72-b21700e80fd5.4JBQYJ0cVTq1gsp9DWf7wTZG6DwG55:t82GW6hga3hJS8O3WWvXKQ== | convertfrom-Json).value
$n8nURL = (bws.exe secret get 2f62489a-31a3-4e31-a088-b21700e75610 -t 0.2530736b-47f1-4d7d-9a72-b21700e80fd5.4JBQYJ0cVTq1gsp9DWf7wTZG6DwG55:t82GW6hga3hJS8O3WWvXKQ== | convertfrom-Json).value

# Asset Name
$assetName = $ENV:COMPUTERNAME

# grab the Meshcentral ID from the agent.exe
$meshNodeID = & "$meshAgent" $meshParms
$meshFullURL = $meshURL + $meshNodeID

$AssetFields = @{
    "name" = $assetName
    "meshagent" = "$meshFullURL"
}

$request = Invoke-WebRequest -Uri $n8nURL -Method POST -Body $AssetFields -UseBasicParsing