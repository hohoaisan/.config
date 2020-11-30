# https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup
# Import neccessary modules
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Agnoster

# Hide current user@host for better looking
$global:DefaultUser = [System.Environment]::UserName

# Variables for saving and accessing desired working directory
$GLOBAL:svdir="D:/Coding/TikiClone"
$GLOBAL:prevdir=pwd

function GetStringBetweenTwoStrings($firstString, $secondString, $importPath){
    $file = Get-Content $importPath
    $pattern = "$firstString(.*?)$secondString"
    $result = [regex]::Match($file,$pattern).Groups[1].Value
    return $result
}
function SaveCurrentDirectory {
    $path = $PROFILE
    $svdir = "`$GLOBAL:svdir=`"$(pwd)`"" -replace '\\', "/"
    (Get-Content -path $path) -replace '(?m)^\$GLOBAL:svdir=.*', "$svdir" | Set-Content -Path $path
    $GLOBAL:svdir = pwd
}
function SavedDirectory {
    # Save current directory and consider it as previous directory
    $GLOBAL:prevdir = pwd
    # Get saved directory and jump to it
    $result =  GetStringBetweenTwoStrings -firstString "GLOBAL:svdir=`"" -secondString "`"" -importPath $PROFILE
    cd $result
}
function PreviousDirectory {
    # Jump to the directory before jumping
    cd $GLOBAL:prevdir
}

function Open-CurDirInExplorer {
    explorer .
}
Set-Alias -Name cd+ -Value SaveCurrentDirectory
Set-Alias -Name cd= -Value SavedDirectory
Set-Alias -Name cd- -Value PreviousDirectory
Set-Alias -Name open -Value Open-CurDirInExplorer

# Autocompletion for arrow-up and down keys
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
