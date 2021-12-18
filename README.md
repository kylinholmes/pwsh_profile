# pwsh_profile
backup my profile... and share some function.
## 添加至`$profile`文件

## 添加用户环境变量
```powershell
New-Alias ade   Add-UserEnvironmentVariable
function Add-UserEnvironmentVariable($NewPath){
        $PreviousPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
        $New = "$PreviousPath;$NewPath"
        [System.Environment]::SetEnvironmentVariable("Path", "$New", "User")
        return New-Object psobject -Property @{Path = $New -split ";"}
}
```
**Useage**
```powershell
ade Test
```
## 设置pwsh代码提示，版本要大于7.15
```powershell
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
```

## 查询mac生产厂商信息
```powershell
New-Alias gmi   Get-MacInfo
function Get-MacInfo($MacAddress){
        iwr "https://api.maclookup.app/v2/macs/$MacAddress" | ConvertFrom-Json
}
```


## 更改文件所有权
```powershell
New-Alias chown Set-Owner
function Set-Owner([string]$Path,[string]$Owner){
        $ACL = Get-Acl $Path
        $User = New-Object System.Security.Principal.Ntaccount($Owner)
        $ACL.SetOwner($User)
        $ACL | Set-Acl -Path $Path
        return acl $Path
}
```
**Useage**
```powershell
chown test Kylin
```
