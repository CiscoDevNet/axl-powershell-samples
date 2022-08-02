[CmdletBinding()]param (
   [Parameter(Mandatory=$true)][string]$axlhost,
   [Parameter(Mandatory=$true)][string]$user,
   [Parameter(Mandatory=$true)][String]$password
)
. .\.env.ps1
. .\include\xml_pretty_print.ps1
. .\include\output_error.ps1

# To skip checking AXL SSL certificate, uncomment the below block.
#     Otherwise to verify a self-signed CUCM certificate, download
#     the CUCM Tomcat certificate in .der format and install into the 
#     Trusted Root Certificates store using certlm
. .\include\trust_all_policy.ps1

# The elements below 
$body = @'
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/14.0">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:executeSQLQuery sequence="1">
         <sql>SELECT device.pkid,device.name FROM device LEFT OUTER JOIN enduserdevicemap 
              ON device.pkid = enduserdevicemap.fkdevice 
              WHERE device.tkproduct = 390 
                AND enduserdevicemap.fkenduser IS NULL</sql>
      </ns:executeSQLQuery>
   </soapenv:Body>
</soapenv:Envelope>
'@

$url = "https://"+$axlhost+":8443/axl/"
$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object Management.Automation.PSCredential ($user, $pass)
$headers = @{
   'SOAPAction' = '"CUCM:DB ver=14.0 executeSQLQuery"'
   'Content-Type' = 'text/xml'
}

try {
   $Result = Invoke-RestMethod -Method Post -Uri $url -Headers $headers -Credential $cred -Body $body
}
catch {
   Write-Host "`r`n<executeSQLQuery>: FAILED"
   output_error
   Exit
}

$xml = Format-XML($result)

Write-Host "`r`n<addLine>: SUCCESS`r`nResponse:"
Write-Host $xml+"`r`n"

$namespaces = @{
    soapenv = "http://schemas.xmlsoap.org/soap/envelope/"
    ns = "http://www.cisco.com/AXL/API/14.0" }
$deviceList = Select-Xml -XPath '//soapenv:Envelope/soapenv:Body/ns:executeSQLQueryResponse/return/row/pkid' -Content $xml -Namespace $namespaces

Write-Host "Orphaned CSF Devices`r`n==================="
$deviceList | ForEach-Object { Write-Host $_.Node.InnerXml }