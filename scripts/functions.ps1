function gem {
    $temp = [System.IO.Path]::GetTempFileName()

    # forward pipeline input if present; otherwise run directly
    if ($input.MoveNext()) {
        $input.Reset()
        $input | gemini.exe @args > $temp
    } else {
        gemini.exe @args > $temp
    }

    $lessCmd = Get-Command less -ErrorAction SilentlyContinue

    if ($lessCmd) {
        less $temp
    }

    Get-Content $temp

    Remove-Item -Force $temp
}

function get_previous_command {
    return (Get-History -Count 1).CommandLine
}

function list_repo {
    $ghCmd = Get-Command gh -ErrorAction SilentlyContinue
    if(!$ghCmd)  { Write-Host "Error: gh not found"; return -1 }

    $repo_list = gh repo list --json nameWithOwner --jq '.[].nameWithOwner'

    echo $repo_list
}

function clone {
    $fzfCmd = Get-Command fzf -ErrorAction SilentlyContinue

    if(!$fzfCmd) { Write-Host "Error: fzf not found"; return -1 }

    $selected_repos = list_repo | fzf -m

    if($selected_repos.Count -eq 0) {
        echo "No repo selected"
    }else {
        foreach ($repo in $selected_repos) {
            gh repo clone $repo
        }
    }
}

function repo {
    [CmdletBinding()]
    param(
        [switch]$o
    )

    if($o) {
        $remote = git config --get remote.origin.url

        if (!$remote) {
            Write-Host "Error: Not a git repository or no remote origin set." -ForegroundColor Red
            return
        }

        # clean SSH format (git@github.com:user/repo.git) to HTTPS format if needed
        $url = $remote -replace '^git@github\.com:', 'https://github.com/' -replace '\.git$', ''
        Start-Process $url
        return
    }

    $fzfCmd = Get-Command fzf -ErrorAction SilentlyContinue

    if(!$fzfCmd) { Write-Host "Error: fzf not found"; return -1 }

    $selected_repos = list_repo | fzf -m

    if($selected_repos.Count -eq 0) {
        echo "No repo selected"
    }else {
        foreach ($repo in $selected_repos) {
            start "https://github.com/$repo"
        }
    }
}
