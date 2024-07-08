$epicorFolder = 'C:\Epicor\ERP11.2.400.15Client\Client'

if (!(test-path -Path $epicorFolder)) {
    THROW 'Epicor not installed'
}
else {
    continue
}