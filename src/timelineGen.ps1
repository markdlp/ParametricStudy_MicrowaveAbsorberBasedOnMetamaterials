# Directory containing the PNG files
$directory = "img\"

# Output timeline file
$timelineFile = Join-Path $directory "timeline.txt"

# Get all PNG files and sort them
$pngFiles = Get-ChildItem -Path $directory -Filter "*.png" | Sort-Object Name

# Write the timeline file
$timelineContent = $pngFiles | ForEach-Object {
    # Generate line with filename and its frame index
    "$:: $([array]::IndexOf($pngFiles, $_) + 1)"
}

# Save the timeline content to the file
$timelineContent | Set-Content -Path $timelineFile

Write-Host "Timeline file generated at $timelineFile"
