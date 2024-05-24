Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select ancestor Mod'
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(500,25)
$label.Text = 'Please Select a Mod to inherit from:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(25,50)

[int]$itemcount = 0

Get-ChildItem -Path $args[0] | 
    ForEach-Object{
        [void] $listBox.Items.Add($_.BaseName)
        $itemcount = $itemcount + 1
    }
[int]$boxHeight = [math]::Min($itemcount * 25, 300)

$listBox.Size = New-Object System.Drawing.Size(450,$boxHeight)
$listBox.Height = $boxHeight

[int]$windowHeight = $boxHeight + 150
[int]$buttonsStart = $boxHeight + 75

$form.Size = New-Object System.Drawing.Size(500,$windowHeight)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(25,$buttonsStart)
$okButton.Size = New-Object System.Drawing.Size(75,25)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,$buttonsStart)
$cancelButton.Size = New-Object System.Drawing.Size(75,25)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)




$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $listBox.SelectedItem
    $x
}