# This script requires powershell 7
# created by: slinkytoad

# revision Log:
# 2-jul-2024 - Updated script to encompass using the Hudu Powershell module to eliminate storing credentials in the script and Github
# 24-oct-2024 - updated script to include company name and to exclude specific tags

import-module HuduAPI
# setup Hudu
# Get a Hudu API Key from https://yourhududomain.com/admin/api_keys
$HuduAPIKey = (bws.exe secret get 878de665-5841-4a37-a307-b21900f0b9ef | convertfrom-Json).value
# Set the base domain of your Hudu instance without a trailing /
$hududomain = (bws.exe secret get c9067ca6-0fa9-4922-ac57-b21900f234da | convertfrom-Json).value
New-HuduAPIKey $HuduAPIKey
New-HuduBaseURL $hududomain

$ZammadCreds = Get-HuduPasswords -Name "IT Helpdesk - Report API Key"
$emailTo = $(Get-HuduPasswords -Name "IT HelpDesk - Report To Address").password
$emailFrom = $(Get-HuduPasswords -Name "IT Helpdesk - Report From Address").password

$baseURL = $ZammadCreds.username
$headers = @{}
$headers.Add("Accept", "application/json")
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", "Token $($ZammadCreds.password)")

# unchanging variables

#$createdTickets = [System.Collections.Generic.List[Object]]::new()
$closedTickets = [System.Collections.Generic.List[Object]]::new()
$openTickets = [System.Collections.Generic.List[Object]]::new()

# grab the current customer list instead of doing a look up each time against the API

$uri = $baseURL + "users/search?query=role_ids:3&limit=300"

$customers = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

###### Organizations ######

$uri = $baseURL + "organizations"

$organizations = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

###### Ticket States ######

$uri = $baseURL + "ticket_states"

$ticketState = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

##### Ticket Priorities ######

$uri = $baseURL + "ticket_priorities"

$ticketPriorities = Invoke-RestMethod -Uri $uri -Headers $headers -method Get

##### Grabbing all tickets that are currently open #####

$uri = $baseURL + "tickets/search?query=state.name%3A(!closed%20AND%20!merged)%20AND%20tags%3A(!automatic)&limit=100"

$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

$ticketIDs = $response.tickets

# we need to grab each of those tickets now to get the information about each one

foreach ($ticket in $ticketIDs) {
    $uri = $baseURL + "tickets/$ticket"
    $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

    $customer = $customers | Where-Object {$_.id -like $response.customer_id}
    $customerName = $customer.firstname + " " + $customer.lastname

    $custOrg = $organizations | Where-Object {$_.id -like $response.organization_id}

    $owner = $customers | Where-Object {$_.id -like $response.owner_id}
    $ownerName = $owner.firstname + " " + $owner.lastName

    $addline = [PScustomObject][Ordered]@{
        number = $response.number
        title = $response.title
        customer = $customerName
        company = $custOrg.name
        state = ($ticketState | Where-Object {$_.id -like $response.state_id}).name
        owner = $ownerName
        priority = ($ticketPriorities | Where-Object {$_.id -like $response.priority_id}).name
        type = $response.type
        created_at = $response.created_at
        on_hold_reason = $response.on_hold_reason
        pending_reason = $response.pending_reason
    }
    $openTickets.Add($addline)
}

# dump the tickets to the console for testing
$openTickets = $openTickets | Sort-Object -Property created_at -Descending

$openTicketsHTML = $openTickets | ConvertTo-Html -Fragment

##### Grabbing all tickets that were created in the last 7 days #####

#$uri = $baseURL + "tickets/search?query=created_at%3A(%3Enow-7d)%20AND%20tags%3A(!automatic)&limit=100"

# this will return all the ticket numbers based on the above uri
#$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

#$ticketIDs = $response.tickets

# we need to grab each of those tickets now to get the information about each one

#foreach ($ticket in $ticketIDs) {
#    $uri = $baseURL + "tickets/$ticket"
#    $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
#
#    $customer = $customers | Where-Object {$_.id -like $response.customer_id}
#    $customerName = $customer.firstname + " " + $customer.lastname
#
#    $addline = [PScustomObject][Ordered]@{
#        number = $response.number
#        title = $response.title
#        customer = $customerName
#        state = ($ticketState | Where-Object {$_.id -like $response.state_id}).name
#        priority = ($ticketPriorities | Where-Object {$_.id -like $response.priority_id}).name
#        created_at = $response.created_at
#        closed_at = $reponse.close_at
#    }
#    $createdTickets.Add($addline)
#}

#$createdTickets = $createdTickets | Sort-Object -Property created_at -Descending

#$createdTicketsHTML = $createdTickets | ConvertTo-Html -Fragment

##### Grabbing all tickets that were closed in the last 7 days #####

$uri = $baseURL + "tickets/search?query=close_at%3A(%3Enow-7d)%20AND%20tags%3A(!automatic)&limit=100"

# this will return all the ticket numbers based on the above uri
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

$ticketIDs = $response.tickets

# we need to grab each of those tickets now to get the information about each one

foreach ($ticket in $ticketIDs) {
    $uri = $baseURL + "tickets/$ticket"
    $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

    $customer = $customers | Where-Object {$_.id -like $response.customer_id}
    $customerName = $customer.firstname + " " + $customer.lastname

    $custOrg = $organizations | Where-Object {$_.id -like $response.organization_id}

    $owner = $customers | Where-Object {$_.id -like $response.owner_id}
    $ownerName = $owner.firstname + " " + $owner.lastName

    $addline = [PScustomObject][Ordered]@{
        number = $response.number
        title = $response.title
        customer = $customerName
        company = $custOrg.name
        state = ($ticketState | Where-Object {$_.id -like $response.state_id}).name
        owner = $ownerName
        priority = ($ticketPriorities | Where-Object {$_.id -like $response.priority_id}).name
        created_at = $response.created_at
        closed_at = $response.close_at
    }
    $closedTickets.Add($addline)
}
# dump the tickets to the console for testing
$closedTickets = $closedTickets | Sort-Object -Property closed_at -Descending

$closedTicketsHTML = $closedTickets | ConvertTo-Html -Fragment

##### Create the HTML Message #####

$htmlhead = "<html>
	   <style>
	   BODY{font-family: Arial; font-size: 8pt; -webkit-print-color-adjust:exact;}
	   H1{font-size: 22px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
	   H2{font-size: 18px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
	   H3{font-size: 16px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
	   TABLE{border: 1px solid black; border-collapse: collapse; font-size: 8pt;}
       tr{page-break-inside: avoid;}
	   TH{border: 1px solid #969595; background: #dddddd; padding: 5px; color: #000000;}
	   TD{border: 1px solid #969595; padding: 5px; }
	   td.pass{background: #B7EB83;}
	   td.warn{background: #FFF275;}
	   td.fail{background: #FF2626; color: #ffffff;}
	   td.info{background: #85D4FF;}
       
	   </style>
	   <body>
           <div align=center>
           <p><h1>IT Department Weekly Update</h1></p>
           <p><h2><b></b></h2></p>
           <p><h3>Generated: " + (Get-Date -format g) + "</h3></p></div>"

$fullHTMLReport = $htmlhead + "<p><h3><b> Open Tickets, sorted by date created. </b></h3></p>" + $openTicketsHTML + "<p><h3><b> Closed Tickets in the last week, sorted by date closed. </b></h3></p>" + $closedTicketsHTML

#######      Create the email        #######

$emailParams = @{
    SmtpServer   = "mail.smtp2go.com"
    Port         = 2525
    UseSsl       = $true
    Priority     = "High"
    From         = $emailFrom
    To           = "ppalmersheim@cjmoyna.com"
    Subject      = "IT Department Weekly Update"
    Body         = $fullHTMLReport
    BodyAsHtml   = $true
}

#######      try to send the email        #######

try {
    Send-MailMessage @emailParams
}
catch {
    Write-Host "Error occured" $_
}

#To           = $emailTo