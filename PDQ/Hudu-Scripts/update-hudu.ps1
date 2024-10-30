# this script will pull all active computers from AD and put them into Hudu
# it checks to see if the asset is already there and if not, makes a new asset.
# it only matches off the name of the asset, so make sure they match the host name if you already have assets in there

####################---- Settings ---- ####################
# Get a Hudu API Key from https://yourhududomain.com/admin/api_keys
$HuduAPIKey = (bws.exe secret get 878de665-5841-4a37-a307-b21900f0b9ef | convertfrom-Json).value
# Set the base domain of your Hudu instance without a trailing /
$hududomain = (bws.exe secret get c9067ca6-0fa9-4922-ac57-b21900f234da | convertfrom-Json).value
# Asset Name as it stands in Hudu
$HuduAssetLayoutName = "Computer Assets"
# company name as it stand in Hudu
# for me, this will be overridden below with our values
$companyName = ""
$magicDashTitle = "AD Sync"

###########################################################

if ([string]::IsNullOrEmpty($companyName)) {
    $domain = (get-computerinfo).CsDomain

    if ($domain -eq ((bws.exe secret get 460505ce-1cf4-4e93-a334-b21900f58b5e | convertfrom-Json).value)) {
        $companyName = (bws.exe secret get e42d2974-cde7-4bc5-bf13-b21900f27bf1 | convertfrom-Json).value
    }
    if ($domain -eq ((bws.exe secret get c49e8401-5d07-4f28-ba1b-b21900f59834 | convertfrom-Json).value)) {
        $companyName = (bws.exe secret get 3dcaccdb-437e-4aa4-aee0-b21900f26721 | convertfrom-Json).value
    }
}
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

$ADActiveComputers = Get-ADComputer -Filter {Enabled -eq $True}
$ADInactiveComputers = Get-ADComputer -Filter {Enabled -eq $False}
$Assets = Get-HuduAssets -companyid $companyid -assetlayoutid $Layout.id

foreach ($computer in $ADActiveComputers) {
    # Check if there is already an asset	
    # Asset Name
    $assetName = $computer.Name
    # See if there is already an asset by this name
    $HuduAsset = ($Assets | Where-Object {$_.name -like $assetName})

    if (!($HuduAsset)) {
        $UpdatedAsset = New-HuduAsset -Name $assetName -CompanyId $companyid -AssetLayoutId $Layout.id
        Write-host "Created $($UpdatedAsset.asset.name)"
    }
    sleep(.2)
}

foreach ($computer in $ADInactiveComputers) {
    # Check if there is already an asset	
    # Asset Name
    $assetName = $computer.Name
    
    $HuduAsset = ($Assets | Where-Object {$_.name -like $assetName})

    if (!($HuduAsset)) {
        Continue
    }else {
        if ($HuduAsset.archived -eq $false) {
            write-host $assetName
            Set-HuduAssetArchive -id $HuduAsset.id -CompanyId $companyid -archive $true -confirm:$false
        }
    }
    sleep(.2)
}

$date = Get-Date -Format "yyyy-MM-dd"
$time = Get-Date -Format "HH:mm:ss"

Set-HuduMagicDash -Title $magicDashTitle -CompanyName $companyName -icon "fas fa-address-book" -Message "Last Sync <br> $($date) <br> $($time)"