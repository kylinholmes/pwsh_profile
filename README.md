# pwsh_profile
backup my profile... and share some function.
## 添加`profile.ps1`内容至`$profile`文件

## 添加用户环境变量到`Path`
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
gmi 00-74-9C-96-72-55
```

## 更改文件所有权
```powershell
chown test Kylin
```

## 查询ip信息
**需要ipinfo的token**
```powershell
ipi 172.21.145.202
```
