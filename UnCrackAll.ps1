<#
.SYNOPSIS
Multi-file PDF unlocking script

.DESCRIPTION
Simple script to unlock all password-protected PDF files in folder, appending them with " decrypted" suffix

#>

Param(
    [Parameter(Mandatory=$True)]
    [ValidateNotNull()]
    [String]$PathToTarget,
    [String]$PathToCommand = "D:\Files\Software\Tools\qpdf.exe",
    [switch]$Recurse = $true,
    [switch]$Decrypt = $true,
    [string]$ResultsFile = "$($PathToTarget)\results.txt",
    [string]$ErrorLog = "$($PathToTarget)\errors.txt"
)
if(-not $Decrypt)
{
    Write-Host "Simulation mode. No changes will be made."
}
if(-not (Test-Path $PathToTarget))
{
    Throw $MyInvocation.MyCommand.Source+" : Invalid directory Path specified"
}
else
{
    $Files = @(Get-ChildItem -Path:$PathToTarget -include:"*.pdf" -recurse:$Recurse)

    if($Files.Count.Equals(0))
    {
        Throw $MyInvocation.MyCommand.Source+" : This directory Path has no PDF files inside"
        exit
    }
    else
    {
        New-Item $ResultsFile -type file | Out-Null
        New-Item $ErrorLog -type file | Out-Null
        $i=1

        foreach ($File in $Files) {
            if($PSBoundParameters['Verbose']){
                Write-Host -NoNewline "["($i++)"/"$Files.Count"] "
            }
            $OutputVariable = [String](Invoke-Expression -Command:"$PathToCommand $([char]34)$file$([char]34) --show-encryption")
            if(-not $OutputVariable)
            {
                if($PSBoundParameters['Verbose']){
                    Write-Host "EmptyOutputVariable:$($file)"
                }
                Add-Content $ErrorLog "EmptyOutputVariable:$($file)"
                continue
            }
            if ($OutputVariable.Contains("File is not encrypted"))
            {
                if($PSBoundParameters['Verbose']){
                    Write-Host $file.Name "is a non encrypted file"
                }
                continue
            }
            elseif ($OutputVariable.Contains("file is damaged"))
            {
                if($PSBoundParameters['Verbose']){
                    Write-Host "DamagedFile:$($file)"
                }
                Add-Content $ErrorLog "DamagedFile:$($file)"
                continue
            }
            else
            {
                if($PSBoundParameters['Verbose']){
                    Write-Host $file.Name "is encrypted. Processing..."
                }
                if($Decrypt)
                {
                    Invoke-Expression -Command:"$PathToCommand  --decrypt $([char]34)$($file)$([char]34) $([char]34)$($File) decrypted.pdf$([char]34)"
                    if(-not (Test-Path "$($File) decrypted.pdf"))
                    {
                        if($PSBoundParameters['Verbose']){
                            Write-Host "ResultFileNotFound:$($file)"
                        }
                        Add-Content $ErrorLog "ResultFileNotFound:$($file)"
                    }
                    else {
                        Rename-Item $($file) "$($File.BaseName).encrypted"
                        Rename-Item "$($file.Directory)\$($file.BaseName).pdf decrypted.pdf" "$($File.BaseName).pdf"
                        Add-Content $ResultsFile "Decrypted:$($file)"
                    }
                }
                continue
            }
        }

    }
    If ((Get-Content $ResultsFile) -eq $Null) {
        Remove-Item $ResultsFile
        Write-Host "No files were decrypted"
    }
    else {
        Write-Host "Consult $($ResultsFile) for the list of decrypted files"
    }

    If ((Get-Content $ErrorLog) -eq $Null) {
        Remove-Item $ErrorLog
        #Write-Host "No errors were present"
    }
    else {
        Write-Host "Consult $($ErrorLog) for error log"
    }
}