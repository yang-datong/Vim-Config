function cl {
  clear
}

function getFileName {
  param (
# 默认路径为当前目录
      [string]$Path = "."
      )
    Get-ChildItem -Path $Path | Format-Wide -Column 5 -Property Name
}


# 静默删除，防止出错
Remove-Item alias:\ls -ErrorAction SilentlyContinue
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
Set-Alias sudo gsudo


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
#在脚本真正执行的时候有时候可能会有延迟
    Start-Sleep -Milliseconds 100
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

# 静默删除，防止出错
Remove-Item alias:\cd -ErrorAction SilentlyContinue
Set-Alias cd mycd


#设置代理
$env:HTTP_PROXY="http://127.0.0.1:7890"; $env:HTTPS_PROXY="http://127.0.0.1:7890"

function prompt {
  Write-Host -NoNewLine -ForegroundColor White "$"
    return " "
}


#oh-my-posh init pwsh | Invoke-Expression
