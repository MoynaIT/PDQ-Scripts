$epicorFolder = 'C:\Epicor'
$tempFolder = 'C:\temp'

if (!(test-path -Path $tempFolder)) {
    new-item -Path $tempFolder -ItemType Directory
}
else {
    continue
}

if (!(test-path -Path $epicorFolder)) {
    new-item -path $tempFolder -ItemType Directory
}
else {
    continue
}