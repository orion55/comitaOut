$curDir = Split-Path -Path $myInvocation.MyCommand.Path -Parent

[string]$tmp = "$curDir\temp"
[boolean]$debug = $true

#архив
[string]$440pArhive = "$tmp\440p\Arhive"

#входящие - настройки
[string]$outcomingPost = "$tmp\Post"
[string]$incomingFiles = "AFN_7102803_MIFNS00_*_000??.arj"
[string]$comitaOutPath = "$tmp\comitaOut"

$curDate = Get-Date -Format "ddMMyyyy"
[string]$logName = $curDir + "\log\" + $curDate + "_comita.log"

#настройка почты
#[string]$mail_addr = "tmn-f365@tmn.apkbank.apk"
[string]$mailAddr = "tmn-goe@tmn.apkbank.ru"
[string]$mailServer = "191.168.6.50"
[string]$mailFrom = "robot311@tmn.apkbank.apk"

[string]$arj32 ="$curDir\util\arj32.exe"