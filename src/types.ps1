
. "$PSScriptRoot\loggers\ChecklistLogger.ps1"
. "$PSScriptRoot\loggers\StreamLogger.ps1"

class LoggingContext {
  [string] $Tab = "  "
  [string] $Prefix = "BEGIN "
  [string] $Suffix = "END "
  [int] $Depth = 0
  [scriptblock] $Write = { Param($s) Write-Host $s }
}

class Requirement {
  [ValidateNotNullOrEmpty()]
  [string] $Name = (New-Guid)
  [ValidateNotNullOrEmpty()]
  [string] $Describe
  [scriptblock] $Test
  [scriptblock] $Set
  [string[]] $DependsOn
}