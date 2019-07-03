
."$PSScriptRoot\formatters.ps1"

function invoke($Requirement) {
    [RequirementEvent]::new($Requirement, "Test", "Start")
    [RequirementEvent]::new($Requirement, "Test", "Stop", $false)
    [RequirementEvent]::new($Requirement, "Set", "Start")
    [RequirementEvent]::new($Requirement, "Set", "Stop", $null)
    [RequirementEvent]::new($Requirement, "Validate", "Start")
    [RequirementEvent]::new($Requirement, "Validate", "Stop", $true)
}

Describe "formatters" {
    Mock Get-Date { return "00:00:00" }
    $script:InDesiredState = 0
    $requirement = @{
        Name     = "simple-requirement"
        Describe = "Simple Requirement"
        Test     = { $script:InDesiredState++ }
        Set      = { }
    }
    $events = invoke $requirement
    $tempContainer = if ($env:TEMP) { $env:TEMP } else { $env:TMPDIR }
    Context "Format-Table" {
        $output = $events | Format-Table | Out-String
        It "Should print a non-empty string" {
            $output.Trim().Length | Should -BeGreaterThan 10
        }
    }
    Context "Format-Checklist" {
        $path = "$tempContainer\$(New-Guid).txt"
        $events | Format-Checklist *> $path
        $output = Get-Content $path -Raw
        Remove-Item $path
        It "Should format each line as a checklist" {
            $output | Should -Match "^\d\d:\d\d:\d\d \[ . \] Simple Requirement"
        }
    }
    Context "Format-Callstack" {
        $path = "$tempContainer\$(New-Guid).txt"
        $events | Format-CallStack *> $path
        $output = Get-Content $path
        Remove-Item $path
        It "Should format each line as a callstack" {
            $output | % { $_ | Should -Match "^\d\d:\d\d:\d\d \[.+\] .+" }
        }
        It "Should print 6 lines" {
            $output.Count | Should -Be 6
        }
    }
}
