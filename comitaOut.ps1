#Программа для копирования файлов-архивов из системы Comita
#(c) Гребенёв О.Е. 28.12.2019

[string]$curDir = Split-Path -Path $myInvocation.MyCommand.Path -Parent
Set-Location $curDir
[string]$lib = "$curDir\lib"

. $curDir/variables.ps1
. $lib/PSMultiLog.ps1
. $lib/libs.ps1

Clear-Host

Start-HostLog -LogLevel Information
Start-FileLog -LogLevel Information -FilePath $logName -Append

#проверяем существуют ли нужные пути и файлы
testDir(@($440pArhive, $outcomingPost, $comitaOutPath))

Write-Log -EntryType Information -Message "Начало работы ComitaOut"

if ($debug) {
	Remove-Item "$comitaOutPath\*.*"
	Copy-Item -Path "$tmp\work1\*.*" -Destination $comitaOutPath
}

$arjFiles = Get-ChildItem "$comitaOutPath\$incomingFiles"
if (($arjFiles | Measure-Object).count -gt 0) {
	$curDate = Get-Date -Format "ddMMyyyy"
	$arhivePath = $440pArhive + '\' + $curDate
	if (!(Test-Path $arhivePath)) {
		New-Item -ItemType directory -Path $arhivePath | out-Null
	}
	$msg = $arjFiles | Copy-Item -Destination $arhivePath -Verbose -Force *>&1
	Write-Log -EntryType Information -Message ($msg | Out-String)

	$msg = $arjFiles | Move-Item -Destination $outcomingPost -Verbose -Force *>&1
	Write-Log -EntryType Information -Message ($msg | Out-String)

	$files = Get-ChildItem "$outcomingPost\$incomingFiles"

	$body = "Архив(ы) с отчетностью успешно скопирован(ы) на отправку`n"
	$msg = $files | ForEach-Object { $_.Name } | Out-String
	$body += $msg
	if (($files | Measure-Object).count -gt 0) {
		if (Test-Connection $mailServer -Quiet -Count 2) {
			$encoding = [System.Text.Encoding]::UTF8
			$title = "Архив(ы) на отправке"
			Send-MailMessage -To $mailAddr -Body $body -Encoding $encoding -From $mailFrom -Subject $title -SmtpServer $mailServer
		}
		else {
			Write-Log -EntryType Error -Message "Не удалось соединиться с почтовым сервером $mailServer"
		}
		Write-Log -EntryType Information -Message $body
	}
}
else {
	Write-Log -EntryType Error -Message "Файлы архивов в каталоге $comitaOutPath не найдены!"
}

Write-Log -EntryType Information -Message "Конец работы скрипта!"

Stop-FileLog
Stop-HostLog