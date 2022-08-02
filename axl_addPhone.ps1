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
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://www.cisco.com/AXL/API/12.5">
  <SOAP-ENV:Body>
    <ns1:addPhone>
      <phone>
        <name>CSFTESTPHONE</name>
        <product>Cisco Unified Client Services Framework</product>
        <class>Phone</class>
        <protocol>SIP</protocol>
        <protocolSide>User</protocolSide>
        <devicePoolName>Default</devicePoolName>
        <lines>
        	<lineIdentifier>
        		<directoryNumber>9876543210</directoryNumber>
        		<routePartition/>
        	</lineIdentifier>
        </lines>
        <commonPhoneConfigName/>
        <locationName>Hub_None</locationName>
        <useTrustedRelayPoint/>
        <sipProfileName>Standard SIP Profile</sipProfileName>
        <phoneTemplateName xsi:nil="true"/>
        <primaryPhoneName xsi:nil="true"/>
        <builtInBridgeStatus/>
        <packetCaptureMode/>
        <certificateOperation/>
        <deviceMobilityMode/>
      </phone>
    </ns1:addPhone>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
'@

$url = "https://"+$axlhost+":8443/axl/"
$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object Management.Automation.PSCredential ($user, $pass)
$headers = @{
   'SOAPAction' = '"CUCM:DB ver=14.0 addPhone"'
   'Content-Type' = 'text/xml'
}

try {
   $Result = Invoke-RestMethod -Method Post -Uri $url -Headers $headers -Credential $cred -Body $body
}
catch {
   Write-Host "`r`n<addPhone>: FAILED"
   output_error
   Exit
}

$xml = Format-XML($result)

Write-Host "`r`n<addLine>: SUCCESS`r`nResponse:"
Write-Host $xml+"`r`n"


