$env:CUSTOM_PROFILE = $PSScriptRoot
$env:BAT_PAGER = "less"

. "$PSScriptRoot\scripts\_env.ps1"
. "$PSScriptRoot\scripts\_prompt.ps1"

# sourcing every pwsh script inside ./scripts/ except for the ones that begin with "_" (e.g _ignored.ps1)
& {
    $ScriptFolder = Join-Path $PSScriptRoot "scripts"

    if(Test-Path $ScriptFolder) {
        Get-ChildItem -Path $ScriptFolder -Filter *.ps1 |
        Where-Object { !$_.Name.StartsWith("_") } |
        ForEach-Object {
            . $_.FullName
        }
    }
}
