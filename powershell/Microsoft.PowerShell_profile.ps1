function cl {
	clear
}

function getFileName{
	Get-ChildItem | Format-Wide -Column 5 -Property Name
}

Remove-Item alias:\ls
Set-Alias ls getFileName

Set-Alias ll Get-ChildItem

Set-Alias l Get-ChildItem

function Format-Status {
    param (
        $Message,
        $Status,
        [System.ConsoleColor]
        $ForegroundColor,
        $BackgroundColor,
        [int]
        $Pading = 80
    )
    Write-Host $message.PadRight($Pading) -NoNewline
    Start-Sleep -Milliseconds 100 #在脚本真正执行的时候有时候可能会有延迟
    Write-Host "[ " -NoNewline
    if ($ForegroundColor -and $BackgroundColor) {
        Write-Host $Status -ForegroundColor:$ForegroundColor -NoNewline -BackgroundColor:$BackgroundColor
    }
    elseif ($ForegroundColor) {
        Write-Host $Status -ForegroundColor:$ForegroundColor -NoNewline  
    }
    elseif ($BackgroundColor) {
        Write-Host $Status -NoNewline -BackgroundColor:$BackgroundColor
    }
    else {
        Write-Host $Status -NoNewline 
    }
    
    Write-Host " ]"
}


