function prompt {
    $path = $PWD.Path;
    $parts = $path.Split([char[]]'\/', [StringSplitOptions]::RemoveEmptyEntries);
    $drive = $parts[0];

    $pathDisplay = switch ($parts.Count) {
        1 { "$drive\" }
        2 { "$drive $($parts[1])" }
        3 { "$drive $($parts[1])\$($parts[2])" }
        default { "$drive $($parts[-3])\..\$($parts[-1])" }
    }

    $gitBranch = "";
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null;
        if ($branch) {
            $isDirty = [bool](git status --porcelain 2>$null);
            $color = if ($isDirty) { "`e[1;91m" } else { "`e[1;92m" };
            $gitBranch = " ${color}($branch)`e[0m";
        }
    }

    "`e[1;34m$pathDisplay`e[0m$gitBranch "
}

