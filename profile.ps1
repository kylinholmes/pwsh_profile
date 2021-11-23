# Import module
Import-Module oh-my-posh


# Alias
New-Alias ip    Get-IPAddress
New-Alias vim   nvim.exe
New-Alias exp   explorer.exe
New-Alias lab   jupyter-lab.exe
New-Alias swp   Switch-Proxy
New-Alias fetch Screenfetch
New-Alias ade   Add-UserEnvironmentVariable
New-Alias gmi   Get-MacInfo
New-Alias gma   Get-MacAddress
New-Alias hex 	hastyhex.exe

$hosts = "C:\Windows\System32\drivers\etc\hosts"
$ChromeUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11"

# Config PWSH
#New-PSDrive -Name Arch -PSProvider FileSystem -Root "\\wsl$\Arch2\root" > $null
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
Set-PoshPrompt -Theme space


$env:Proxy_Status = "Off"
function Switch-Proxy ($Protocol="http",$Port=10809){
        $Proxy = $Protocol+"://127.0.0.1:"+$Port
        if($env:Proxy_Status -eq "On"){
                $env:HTTP_PROXY = "";$env:HTTPS_PROXY=""
                $env:Proxy_Status = "Off"
        }
        else{
                $env:HTTP_PROXY = $Proxy;$env:HTTPS_PROXY = $Proxy
                $env:Proxy_Status = "On"
        }
        return New-Object psobject -Property @{Status = $env:Proxy_Status; Proxy_URL= $env:HTTP_PROXY }
}

function Get-IPAddress(){
	$info = Get-NetIPAddress | 
                Where-Object {($_.AddressFamily -ne "IPv6") -and ($_.AddressState -ne "Tentative")} |
                Select-Object  -Property InterfaceIndex,InterfaceAlias,IPAddress | 
                Sort-Object InterfaceIndex
        return $info
}

function Add-UserEnvironmentVariable($NewPath){
        $PreviousPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
        $New = "$PreviousPath;$NewPath"
        [System.Environment]::SetEnvironmentVariable("Path", "$New", "User")
        return New-Object psobject -Property @{Path = $New -split ";"}
}

function Get-MacInfo($MacAddress){
        iwr "https://api.maclookup.app/v2/macs/$MacAddress" | ConvertFrom-Json
}
function Get-MacAddress(){
        Get-NetNeighbor -AddressFamily IPv4 | 
        Where-Object {
                $_.LinkLayerAddress -ne "00-00-00-00-00-00" -and
                $_.LinkLayerAddress -ne "FF-FF-FF-FF-FF-FF" -and
                $_.ifIndex -ne "1"
                } | 
        sort ifIndex
}
