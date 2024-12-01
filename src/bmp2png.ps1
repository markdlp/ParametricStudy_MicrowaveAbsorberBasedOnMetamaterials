[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

Get-ChildItem -File "img\*.bmp" -Recurse | ForEach-Object {
    $bitmap = [System.Drawing.Bitmap]::new($_.FullName)
    $newname = $_.FullName -replace '.bmp$','.png'
    $bitmap.Save($newname, "png")
    $bitmap.Dispose()
}