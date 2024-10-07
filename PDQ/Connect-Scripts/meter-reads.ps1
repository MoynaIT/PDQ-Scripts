# this script is setup for copy paste currently
# set this ip to the ip of the printer
$printer = 'someIPhere'
$community = 'public'

# this oid is to get the total printed pages
$oid = '.1.3.6.1.2.1.43.10.2.1.4.1.1' 

$SNMP = New-Object -ComObject olePrn.OleSNMP
$SNMP.open($($printer),$($community),2,1000)
$RESULT = $SNMP.get($($oid))
$SNMP.Close()
write-host "total pages $($RESULT)"