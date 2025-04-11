Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Web

# JSON-ból olvasható, szép kulcs-érték sorok készítése
function Convert-JsonToPrettyText {
    param ([string]$JsonString)

    try {
        $parsed = $JsonString | ConvertFrom-Json
        $output = ""
        foreach ($prop in $parsed.PSObject.Properties) {
            $output += "$($prop.Name): $($prop.Value)`r`n"
        }
        return $output
    } catch {
        return $JsonString  # ha nem JSON, visszaadja nyersen
    }
}

# JWT token dekódolása
function Decode-JWTToken {
    param (
        [string]$Token
    )

    $parts = $Token -split '\.'
    if ($parts.Count -lt 2) {
        return "⚠️ Érvénytelen token formátum"
    }

    function DecodeBase64Url {
        param ([string]$data)
        $data = $data.Replace('-', '+').Replace('_', '/')
        switch ($data.Length % 4) {
            2 { $data += '==' }
            3 { $data += '=' }
        }
        try {
            $bytes = [System.Convert]::FromBase64String($data)
            return [System.Text.Encoding]::UTF8.GetString($bytes)
        } catch {
            return "⚠️ Hibás base64 kódolás"
        }
    }

    $headerRaw = DecodeBase64Url $parts[0]
    $payloadRaw = DecodeBase64Url $parts[1]

    $headerFormatted = Convert-JsonToPrettyText -JsonString $headerRaw
    $payloadFormatted = Convert-JsonToPrettyText -JsonString $payloadRaw

    return "===== HEADER =====`r`n$headerFormatted`r`n===== PAYLOAD =====`r`n$payloadFormatted"
}

# GUI létrehozása
$form = New-Object System.Windows.Forms.Form
$form.Text = "JWT Token Dekóder"
$form.Size = New-Object System.Drawing.Size(640,580)
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "JWT token bemenet:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($label)

$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Multiline = $true
$inputBox.ScrollBars = "Vertical"
$inputBox.Size = New-Object System.Drawing.Size(600, 80)
$inputBox.Location = New-Object System.Drawing.Point(10,45)
$form.Controls.Add($inputBox)

$decodeButton = New-Object System.Windows.Forms.Button
$decodeButton.Text = "Dekódolás"
$decodeButton.Location = New-Object System.Drawing.Point(10,135)
$decodeButton.Size = New-Object System.Drawing.Size(100,30)
$form.Controls.Add($decodeButton)

$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Text = "Másolás vágólapra"
$copyButton.Location = New-Object System.Drawing.Point(120,135)
$copyButton.Size = New-Object System.Drawing.Size(130,30)
$form.Controls.Add($copyButton)

$saveButton = New-Object System.Windows.Forms.Button
$saveButton.Text = "Mentés fájlba"
$saveButton.Location = New-Object System.Drawing.Point(260,135)
$saveButton.Size = New-Object System.Drawing.Size(100,30)
$form.Controls.Add($saveButton)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.ReadOnly = $true
$outputBox.Size = New-Object System.Drawing.Size(600, 280)
$outputBox.Location = New-Object System.Drawing.Point(10,180)
$form.Controls.Add($outputBox)

# Esemény: Dekódolás
$decodeButton.Add_Click({
    $token = $inputBox.Text.Trim()
    if (-not $token) {
        [System.Windows.Forms.MessageBox]::Show("Kérlek, adj meg egy JWT tokent!", "Hiba", "OK", "Error")
    } else {
        $decoded = Decode-JWTToken -Token $token
        $outputBox.Text = $decoded
    }
})

# Esemény: Másolás vágólapra
$copyButton.Add_Click({
    if ($outputBox.Text) {
        [System.Windows.Forms.Clipboard]::SetText($outputBox.Text)
        [System.Windows.Forms.MessageBox]::Show("A dekódolt tartalom másolva lett a vágólapra.", "Siker", "OK", "Information")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Nincs mit másolni – előbb dekódolj egy tokent!", "Figyelmeztetés", "OK", "Warning")
    }
})

# Esemény: Mentés fájlba
$saveButton.Add_Click({
    if ($outputBox.Text) {
        $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveFileDialog.Filter = "Szövegfájl (*.txt)|*.txt"
        $saveFileDialog.Title = "Mentés dekódolt JWT fájlként"
        if ($saveFileDialog.ShowDialog() -eq "OK") {
            [System.IO.File]::WriteAllText($saveFileDialog.FileName, $outputBox.Text)
            [System.Windows.Forms.MessageBox]::Show("Sikeresen mentve: $($saveFileDialog.FileName)", "Mentve", "OK", "Information")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Nincs mit menteni – előbb dekódolj egy tokent!", "Figyelmeztetés", "OK", "Warning")
    }
})

[void]$form.ShowDialog()

