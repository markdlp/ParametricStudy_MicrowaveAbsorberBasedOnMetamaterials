# Define the total number of frames and the output file name
$numFrames = 90
$fileName = "timeline.txt"

# Create an array starting with the header comment
$content = @("% Auto-generated timeline for $numFrames frames")

# Loop through and build the string for each frame
for ($i = 0; $i -lt $numFrames; $i++) {
    $content += "::$i"
}

# Write the entire array to the text file
$content | Set-Content -Path $fileName

# Confirm completion
Write-Host "Timeline file '$fileName' generated successfully!"