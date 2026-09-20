& {
    $gitCmd = Get-Command git -ErrorAction SilentlyContinue

    if ($gitCmd) {
        $parent = Split-Path -Path $gitCmd.Source -Parent
        $root = Split-Path -Path $parent -Parent
        $lessPath = "$root\usr\bin\less.exe"

        if (Test-Path $lessPath) {
            # Set-Alias and $env modifications naturally remain global
            Set-Alias -Name less -Value $lessPath -Scope Global -Force
            $env:LESS = "-R"
        } else {
            Write-Error "Could not find less.exe at $lessPath"
        }
    } else {
        Write-Error "git.exe not found, cannot resolve less path."
    }
}

& {
    $cmakePath = "C:\Program Files\CMake\bin\cmake.exe"
    if (Test-Path $cmakePath) {
        Set-Alias -Name cmake -Value $cmakePath -Scope Global -Force
    } else {
        Write-Error "Could not find cmake.exe at $cmakePath"
    }
}
