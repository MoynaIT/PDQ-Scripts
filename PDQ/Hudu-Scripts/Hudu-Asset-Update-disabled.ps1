# This script will grab all of the disabled computers from AD 
# and compare them to assets in Hudu and archive them if they are found

####################---- Settings ---- ####################
# Get a Hudu API Key from https://yourhududomain.com/admin/api_keys
$HuduAPIKey = (bws.exe secret get 878de665-5841-4a37-a307-b21900f0b9ef | convertfrom-Json).value
# Set the base domain of your Hudu instance without a trailing /
$hududomain = (bws.exe secret get c9067ca6-0fa9-4922-ac57-b21900f234da | convertfrom-Json).value
#Company Name as it appears in Hudu
$CompanyName = (bws.exe secret get e42d2974-cde7-4bc5-bf13-b21900f27bf1 | convertfrom-Json).value
$HuduAssetLayoutName = "Computer Assets"

###########################################################

# Get the Hudu API Module if not installed
if (Get-Module -ListAvailable -Name HuduAPI) {
    Import-Module HuduAPI 
}
else {
    Install-Module HuduAPI -Force -confirm:$true
    Import-Module HuduAPI
}

# Set Hudu logon information
New-HuduAPIKey $HuduAPIKey
New-HuduBaseUrl $HuduDomain

# setup some common variables for any device
$Company = Get-HuduCompanies -name $CompanyName 
$Layout = Get-HuduAssetLayouts -name $HuduAssetLayoutName
$companyid = $company.id

$ADComputers = Get-ADComputer -Filter {Enabled -eq $False}
$Assets = Get-HuduAssets -companyid $companyid -assetlayoutid $Layout.id

foreach ($computer in $ADComputers) {
    # Check if there is already an asset	
    # Asset Name
    $assetName = $computer.Name
    write-host $assetName
    
    $HuduAsset = ($Assets | Where-Object {$_.name -like $assetName})

    if (!($HuduAsset)) {
        Continue
    }else {
        Set-HuduAssetArchive -id $HuduAsset.id -CompanyId $companyid -archive $true -confirm:$false
    }
    sleep(.2)
}
