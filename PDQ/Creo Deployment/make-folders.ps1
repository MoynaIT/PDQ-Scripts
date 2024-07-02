$folders = 'C:\CAD', 'C:\Trail'

foreach ($folder in $folders) {
    if (!(test-path -path $folder)){
        new-item -Path $folder -ItemType Directory
    }
    else {
        continue
    }
}