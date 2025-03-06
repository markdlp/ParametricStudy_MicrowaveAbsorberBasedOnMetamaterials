# Define the paths to the files
$s11FilePath = "data\s11.txt"
$zFilePath = "data\z.txt"

# Read the first column from s11.txt
$firstColumn = Get-Content $s11FilePath | ForEach-Object {
    ($_ -split '\s+')[0]  # Split each line by whitespace and take the first element
}

# Read the existing content of z.txt
$zContent = Get-Content $zFilePath

# Combine the existing content of z.txt with the first column from s11.txt
$combinedContent = for ($i = 0; $i -lt $zContent.Length; $i++) {
    if ($i -lt $firstColumn.Length) {
        # Append the first column value to the corresponding line in z.txt
        "$($firstColumn[$i])`t$($zContent[$i])"
    } else {
        # If there are more lines in z.txt than in s11.txt, just keep the original line
        $zContent[$i]
    }
}

# Write the combined content back to z.txt
Set-Content -Path $zFilePath -Value $combinedContent

Write-Output "First column from s11.txt has been merged into z.txt."