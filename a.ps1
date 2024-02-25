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

# Select only the Profile Name and Password fields
$selectedData = $wifiPasswords | Select-Object "Profile Name", "Password"

# Convert the data to JSON
$jsonData = $selectedData | ConvertTo-Json

# Specify the path to save the JSON file on the desktop
$jsonFilePath = "$env:USERPROFILE\Desktop\wifi_passwords.json"

# Save the data to the JSON file
$jsonData | Set-Content -Path $jsonFilePath

Write-Host "Wi-Fi profile names and passwords saved to: $jsonFilePath"
