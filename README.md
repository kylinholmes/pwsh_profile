# pwsh_profile
backup my profile... and share some function.
## Usage 
添加`profile.ps1`内容至`$profile`文件
执行以下命令前，记得确保`$PROFILE`路径真的存在，**注意: `>` 会覆盖原有的文件，如果想加在最后用`>>`**
```powershell
iwr https://raw.githubusercontent.com/kylinholmes/pwsh_profile/main/profile.ps1 > $PROFILE
```

## 推荐的函数
### 添加用户环境变量到`Path`
```powershell
ade Test
```

### 查询mac生产厂商信息
```powershell
gmi 00-74-9C-96-72-55
```

### 更改文件所有权
```powershell
chown test Kylin
```

### 查询ip信息
**需要ipinfo的token**
```powershell
ipi 172.21.145.202
```
