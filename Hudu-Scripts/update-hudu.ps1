####################---- Settings ---- ####################
# Get a Hudu API Key from https://yourhududomain.com/admin/api_keys
$HuduAPIKey = "$env:hudu_api_key"
# Set the base domain of your Hudu instance without a trailing /
$hududomain = "$env:hudu_domain"
#Company Name as it appears in Hudu
$CompanyName = "Mobile Track Solutions"
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

$ADComputers = Get-ADComputer -Filter {Enabled -eq $True}

foreach ($computer in $ADComputers) {
    # Check if there is already an asset	
    # Asset Name
    $assetName = $computer.Name
    write-host $assetName
    # See if there is already an asset by this name
    $Asset = Get-HuduAssets -name $assetName -companyid $companyid -assetlayoutid $Layout.id

    if (!($asset)) {
        $UpdatedAsset = New-HuduAsset -Name $assetName -CompanyId $companyid -AssetLayoutId $Layout.id
        Write-host "Created $($UpdatedAsset.asset.name)"
    }else {
        $UpdatedAsset = Set-HuduAsset -Id $Asset.id -name $assetName -CompanyId $companyid -AssetLayoutId $Layout.id
        Write-host "Updated $($UpdatedAsset.asset.name)"
    }
    write-host "sleeping"
    sleep(.2)
}
