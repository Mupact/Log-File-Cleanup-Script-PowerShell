# Defines the helper function to format the LastWriteTime into a yyyy/MM format.
function Format-YearMonth([datetime]$date) {
    # Outputs a stirng in the format "yyyy/MM".
    return '{0:yyyy\\MM}' -f $date 
}

#Sets path for source and target locations.
$sourcePath = 'C:\User\testuser\Desktop\log'
$targetPath = 'C:\Users\testuser\Desktop\log\archive'
# Get the formatted date for the current year and month. 
$thisMonth = Format-YearMonth (Get-Date)
# Retrives the files, of which are removed without folders. 
Get-ChildItem -Path $sourcePath -File -Recurse | 
    # Filters out files that have a LastWriteTime for this month. 
    Where-Object {(Format-YearMonth $_.LastWriteTime) -ne $thisMonth} | 
    ForEach-Object {
    #Sets the destination pat on the file's LastWriteTime (year and month.)
    $Directory = Join-Path -Path $targetPath -ChildPath (Format-YearMonth $_.LastWriteTime)
    # Creates a directory if it is non-existent. 
    if (!(Test-Path $Directory)){
        $null = New-Item $Directory -ItemType Directory
    }
    
    Write-Host "Moving file '$($_.FullName)' to '$Directory" 
    # Move file to a new location
    $_ | Move-Item -Destination $Directory -Force 
} 