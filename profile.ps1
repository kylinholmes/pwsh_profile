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
New-Alias gport Get-TcpPort

$Hosts = "C:\Windows\System32\drivers\etc\hosts"
$env:FB_DATABASE = "C:\Users\Kylin\AppData\Local\VirtualStore\Program Files\filebrowser\filebrowser.db"

Set-PoshPrompt -Theme space


# PSReadLine
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionViewStyle ListView



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
        if(!(Test-Path $NewPath)){
                return "Can not find such path"
        }
        $NewPath = Resolve-Path $NewPath
        $Sort = "$PreviousPath;$NewPath" -split ';'| sort
        $New = [system.String]::Join(";", $Sort)
        echo $New
        [System.Environment]::SetEnvironmentVariable("Path", "$New", "User")
        echo "Add $NewPath to env:Path Success"
        return New-Object psobject -Property @{Path = $NewPath}
}

function Get-MacInfo($MacAddress){
        $res = iwr "https://api.maclookup.app/v2/macs/$MacAddress" | ConvertFrom-Json
        if ($res.found -ne "True"){
                return "Not Found"
        }
        return $res
}

function Get-MacAddress(){
        return Get-NetNeighbor -AddressFamily IPv4 | 
        Where-Object {
                $_.LinkLayerAddress -ne "00-00-00-00-00-00" -and
                $_.LinkLayerAddress -ne "FF-FF-FF-FF-FF-FF" -and
                $_.ifIndex -ne "1"
                } | 
        sort ifIndex
}

function Get-TcpPort($Port){
        $Port = Get-NetTCPConnection -LocalPort $Port | Where-Object {$_.OwningProcess -ne 0}
        $Process = Get-Process -Id $Port.OwningProcess
        return $Process | Select-Object -Property Id,Name,Path
}

function Test-Off(){
	bcdedit /set testsigning off
}


function Get-Users(){
        return Get-LocalGroup | % {Get-LocalGroupMember $_}
}

New-Alias chown Set-Owner
function Set-Owner([string]$Path,[string]$Owner){
        $ACL = Get-Acl $Path
        $User = New-Object System.Security.Principal.Ntaccount($Owner)
        $ACL.SetOwner($User)
        $ACL | Set-Acl -Path $Path
        return acl $Path
}

New-Alias ipi Get-IPinfo
function Get-IPinfo([string] $IPAddress){
        $token = Get-Content C:\Users\Kylin\Documents\PowerShell\IPinfotoken
        $query = "ipinfo.io/" + $IPAddress + "?token=$token"
        return iwr $query | ConvertFrom-Json | Format-List
}
