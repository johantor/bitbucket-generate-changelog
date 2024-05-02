# Bitbucket Generate changelog script
Small powershell script to generate a CHANGELOG.md file based on tags. So for each tag it takes all commits, replaces some naming conventions, sort them and output to the CHANGELOG.md file.

Can be added in a packages file by creating a script:
`"generate-changelog": "@powershell -NoProfile -ExecutionPolicy Unrestricted -Command ./generate-changelog.ps1"`
