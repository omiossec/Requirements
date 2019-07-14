$MainFolder = $PSScriptRoot
$ModuleName = "requirements"

$BuildFolder = join-path -path $MainFolder  -childpath ".builds"

$BuildModulePath =  join-path -path $BuildFolder -ChildPath "$($ModuleName)"

$BuildModuleSrcPath =  join-path -path $BuildModulePath -ChildPath "src"

$SourceFolder = join-path -path $MainFolder  -childpath "src"
$SourceModuleManifest = join-path -path $MainFolder  -childpath "$($ModuleName).psd1"

$PathSeparator = [IO.Path]::DirectorySeparatorChar



if (Test-Path $BuildFolder) {
    Remove-Item -Path $BuildFolder -Force -Recurse -Confirm:$false
}

new-item -Path $BuildFolder -ItemType Directory

new-item -Path $BuildModulePath -ItemType Directory

new-item -Path $BuildModuleSrcPath -ItemType Directory


$BuildModuleManifest = Join-Path -Path $BuildModulePath -ChildPath "$($ModuleName).psd1"




Copy-Item -Path $SourceModuleManifest -Destination $BuildModuleManifest -Force

Copy-Item -Path (join-path -path $MainFolder -ChildPath "LICENSE" ) -Destination (join-path -path $BuildModulePath -ChildPath "LICENSE" )  -Force



$ModuleScriptFiles = Get-ChildItem -Path $SourceFolder   -Exclude @('*.tests.ps1')

foreach ($script in $ModuleScriptFiles){
    
    copy-item -Path $script -Destination (join-path -Path  $BuildModuleSrcPath -ChildPath (Split-Path $script -leaf)) 

    }


