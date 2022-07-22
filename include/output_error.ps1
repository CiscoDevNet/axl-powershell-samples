function output_error {
    $status_code = $_.Exception.Response.StatusCode.Value__
    $status_description = $_.Exception.Response.StatusCode.ToString()
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $Reader.BaseStream.Position = 0
    $Reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Host "StatusCode:" $status_code $status_description
    Write-Host "Output:`r`n" $(Format-XML($responseBody))
    break
    }