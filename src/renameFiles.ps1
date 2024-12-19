$directory = "img\MMA_UnitCell_E_27e2MHz_Zmax1"

# Get all PNG files and sort them
$pngFiles = Get-ChildItem -Path $directory -Filter "*.png" | Sort-Object Name

# Loop through each file
foreach ($file in $pngFiles) {

    $newName = $file.Name -replace "_", "-"

    # Generate the full new path
    # $newPath = Join-Path -Path $directory -ChildPath $newName

    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
}