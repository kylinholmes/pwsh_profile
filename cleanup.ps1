$UserName = $env:UserName
$AimDir = 
"C:\Users\$UserName\AppData\Local\Netease\CloudMusic\Cache",
"C:\Users\$UserName\AppData\Local\pip\cache",
"C:\Users\$UserName\AppData\Local\Yarn\Cache",
"C:\Users\$UserName\AppData\Local\Steam\htmlcache",
"C:\Users\$UserName\AppData\Local\npm-cache\",
"C:\Users\$UserName\AppData\Local\node-gyp\Cache",
"C:\Users\$UserName\Documents\Tencent Files\*\Image\Group2"




$Res = @()
foreach ($i in $AimDir){
	if (Test-Path $i){
		$Size = ((ls -Recurse $i) | Where-Object {$_.Attributes -ne 'Directory'} | Measure-Object -Property Length -Sum).Sum / 1MB
		$Res += New-Object psobject -Property @{ Path = $i ; "Size(MB)" = [Math]::Round($Size) }
		rm -Recurse -Force $i
	}
}
$Res
$tmp = ($Res | Measure-Object -Property "Size(MB)" -Sum ).Sum
$totalSize =  $tmp ? $tmp : 0
echo "Total $totalSize (MB)"
echo "press any key to exit"
$null = [console]::readkey('?')

