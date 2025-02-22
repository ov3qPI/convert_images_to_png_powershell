$count = 0
$total = 0

$files = Get-ChildItem -Path E:\ -Recurse -Include *.jpg, *.jpeg, *.webp
$total = $files.Count

foreach ($file in $files) {
    $outputFile = "$($file.DirectoryName)\$($file.BaseName).png"
    
    try {
        magick $file.FullName -quality 100 $outputFile
        
        if ($?) {
            Remove-Item -Path $file.FullName
            Rename-Item -Path $outputFile -NewName $file.Name
            $count++
            Write-Host "Converted $count out of $total files."
        } else {
            Write-Host "Skipping file: $($file.FullName) (conversion failed)"
        }
    } catch {
        Write-Host "Error converting $($file.FullName): $_"
    }
}
