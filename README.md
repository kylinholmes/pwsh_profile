# pwsh_profile
backup my profile... and share some function.

## Add-UserEnvironmentVariable
```powershell
New-Alias ade   Add-UserEnvironmentVariable
function Add-UserEnvironmentVariable($NewPath){
        $PreviousPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
        $New = "$PreviousPath;$NewPath"
        [System.Environment]::SetEnvironmentVariable("Path", "$New", "User")
        return New-Object psobject -Property @{Path = $New -split ";"}
}
```
## 设置pwsh代码提示，版本要大于7.15
```powershell
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
```

