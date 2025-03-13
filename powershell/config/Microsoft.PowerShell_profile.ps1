function cl {
	clear
}

function getFileName {
  param (
    [string]$Path = "."  # 默认路径为当前目录
  )
  Get-ChildItem -Path $Path | Format-Wide -Column 5 -Property Name
}

Remove-Item alias:\ls -ErrorAction SilentlyContinue # 静默删除，防止出错
Set-Alias ls getFileName

Set-Alias ll Get-ChildItem

Set-Alias l Get-ChildItem

function open {
	    param (
	            [string]$path
		        )
	        Start-Process $path
}

Set-Alias apt choco
Set-Alias vim nvim


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


function mycd {
  param (
    [string]$Path
  )

  if (-not $Path) {
    # 如果没有提供路径，则跳转到用户主目录
    Set-Location $HOME
  } else {
    # 如果提供了路径，则执行默认的 cd 命令
    Set-Location $Path
  }
}

Remove-Item alias:\cd -ErrorAction SilentlyContinue # 静默删除，防止出错
Set-Alias cd mycd


