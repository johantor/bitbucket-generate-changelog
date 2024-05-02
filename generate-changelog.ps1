$previousTag = ""
$output = @()
git tag --sort=-creatordate | ForEach-Object {
    $currentTag = $_
    if ($previousTag -ne "") {
        $tagDate = git log -1 --pretty=format:'%ad' --date=short $previousTag
        $output += "## $previousTag ($tagDate)`n"
        $rows = @()
        $rows  += (git log --oneline "$currentTag...$previousTag" | ForEach-Object {
            $commitHash, $commitMessage = $_.Split(' ', 2)
            $author = (git log -1 --pretty=format:'%an' $commitHash)
            $commitMessage = $commitMessage `
                -replace 'Merged in ', '' `
                -replace 'origin/', ''  `
                -creplace 'Feat:', 'feat: '  `
                -replace 'feature/', 'feat: '  `
                -replace 'feature:', 'feat: ' `
                -replace 'package/', 'package: ' `
                -replace 'renovate/', 'package: ' `
                -replace 'chore/', 'chore: ' `
                -replace 'fix/', 'fix: ' `
                -replace 'bugfix/', 'fix: ' `
                -replace [regex]::Escape('chore(deps-dev): bump'), 'package:'

            if(($author -ne "Renovate") -and ($author -ne "dependabot[bot]")){
                $author = " by $author"
            }else{
                $author = ""
            }
            "- $commitMessage$author"

        })

        $rows | Sort-Object | ForEach-Object {
            $output += $_
        }

        $output += "`n"
    }
    $previousTag = $currentTag
}

$output | Out-File -FilePath "CHANGELOG.md" -Encoding utf8
