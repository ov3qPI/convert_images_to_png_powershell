# Initialize counters
$count = 0
$total = 0

# Count how many .jpg and .jpeg files are in the directory and subdirectories
Get-ChildItem -Path D:\ -Recurse -Include *.jpg, *.jpeg *.webp | ForEach-Object {
    $total++
}

# Process the files
Get-ChildItem -Path D:\ -Recurse -Include *.jpg, *.jpeg *.webp | ForEach-Object {
    $file = $_
    $outputFile = "$($file.DirectoryName)\$($file.BaseName).png"
    
    # Try to convert the file and move it if successful
    try {
        magick $file.FullName -quality 100 $outputFile
        if ($?) {
            Move-Item -Path $outputFile -Destination D:\Pictures\png\
            Remove-Item -Path $file.FullName
            $count++
            Write-Host "Converted $count out of $total files."
        } else {
            Write-Host "Skipping file: $($file.FullName) (conversion failed)"
        }
    } catch {
        Write-Host "Error converting $($file.FullName): $_"
    }
}
