# PowerShell script to convert Matlab figures to pgfplots files

# Default values
$CONVERT_STYLES = 1
$CONVERT_AXES = 1
$OUTFILE = ""
$MAXPOINTS = 100000

# Function to display help
function Show-Help {
    Write-Output "matlab2pgfplots.ps1 [--maxpoints N] [--styles [0|1]] [--axes [0|1]] [-o OUTFILE] INFILE ..."
    Write-Output "Converts Matlab figures (.fig-files) to pgfplots-files (.pgf-files)."
    Write-Output "This script is a front-end for matlab2pgfplots.m (which needs to be in Matlab's search path)."
    Write-Output "Type 'help matlab2pgfplots' at your Matlab prompt for more information."
    exit 0
}

# Parse command-line arguments
$arguments = @()
for ($i = 0; $i -lt $args.Length; $i++) {
    switch ($args[$i]) {
        "--maxpoints" { $MAXPOINTS = $args[++$i]; break }
        "--styles" { $CONVERT_STYLES = $args[++$i]; break }
        "--axes" { $CONVERT_AXES = $args[++$i]; break }
        "-o" { $OUTFILE = $args[++$i]; break }
        "--help" { Show-Help }
        default { $arguments += $args[$i] }
    }
}

# Check if input files are provided
if ($arguments.Length -eq 0) {
    Write-Output "No input files specified."
    exit 1
}

# Check if multiple input files are provided with a single output file
$HAS_OUTFILE = 0
if ($arguments.Length -gt 1 -and $OUTFILE) {
    $HAS_OUTFILE = 1
}

# Process each input file
foreach ($INFILE in $arguments) {
    if ($HAS_OUTFILE -eq 0) {
        $OUTFILE = [System.IO.Path]::ChangeExtension($INFILE, ".pgf")
    }
    Write-Output "$INFILE -> $OUTFILE ..."

    # Create a temporary log file
    $M_LOGFILE = [System.IO.Path]::GetTempFileName()

    # Run Matlab and execute the conversion script
    $matlabScript = @"
    addpath('$PWD'); % Ensure matlab2pgfplots.m is in the path
    f = hgload('$INFILE');
    matlab2pgfplots('$OUTFILE', 'fig', f, 'styles', $CONVERT_STYLES, 'axes', $CONVERT_AXES, 'maxpoints', $MAXPOINTS);
    exit;
"@
    [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($matlabScript)) | Start-Process -FilePath "matlab" -ArgumentList "-nojvm -nodesktop -nosplash -logfile `"$M_LOGFILE`"" -NoNewWindow -Wait -RedirectStandardInput

    # Check for errors in the log file
    $CODE = 0
    if (Select-String -Path $M_LOGFILE -Pattern "Error" -Quiet) {
        Write-Output "Matlab output:" 2>&1
        Get-Content $M_LOGFILE 2>&1
        $CODE = 1
    }

    # Clean up the temporary log file
    Remove-Item $M_LOGFILE

    # Exit if there was an error
    if ($CODE -ne 0) {
        exit $CODE
    }
}