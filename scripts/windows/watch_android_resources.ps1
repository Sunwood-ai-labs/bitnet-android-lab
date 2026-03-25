# Observation helper for live Android-side state over ADB.
# The output can include package and process names from the connected device.
[CmdletBinding()]
param(
    [string]$AdbPath,
    [string]$Serial,
    [ValidateRange(1, 60)]
    [int]$RefreshSeconds = 2,
    [ValidateRange(200, 5000)]
    [int]$CpuSampleMs = 750,
    [ValidateRange(5, 50)]
    [int]$TopRows = 12,
    [ValidateRange(5, 40)]
    [int]$CpuInfoRows = 12,
    [ValidateRange(5, 40)]
    [int]$MemInfoRows = 18,
    [switch]$Once
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-AdbPath {
    param([string]$RequestedPath)

    if ($RequestedPath) {
        if (-not (Test-Path -LiteralPath $RequestedPath)) {
            throw "adb was not found at '$RequestedPath'."
        }
        return (Resolve-Path -LiteralPath $RequestedPath).Path
    }

    $command = Get-Command adb.exe -ErrorAction SilentlyContinue
    if (-not $command) {
        $command = Get-Command adb -ErrorAction SilentlyContinue
    }
    if ($command) {
        return $command.Source
    }

    $candidates = @(
        "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe",
        "$env:USERPROFILE\AppData\Local\Android\Sdk\platform-tools\adb.exe",
        "C:\Android\platform-tools\adb.exe"
    )

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    throw "adb was not found. Pass -AdbPath or install Android platform-tools."
}

function Get-AdbBaseArgs {
    $args = @()
    if ($script:Serial) {
        $args += @("-s", $script:Serial)
    }
    return $args
}

function Invoke-AdbCommand {
    param([string[]]$Arguments)

    $fullArgs = @()
    $fullArgs += Get-AdbBaseArgs
    $fullArgs += $Arguments

    $stdoutPath = [System.IO.Path]::GetTempFileName()
    $stderrPath = [System.IO.Path]::GetTempFileName()

    try {
        $process = Start-Process -FilePath $script:AdbExe `
            -ArgumentList $fullArgs `
            -NoNewWindow `
            -Wait `
            -PassThru `
            -RedirectStandardOutput $stdoutPath `
            -RedirectStandardError $stderrPath
        $exitCode = $process.ExitCode

        $stdoutLines = @()
        if (Test-Path -LiteralPath $stdoutPath) {
            $stdoutLines = Get-Content -LiteralPath $stdoutPath -ErrorAction SilentlyContinue
        }

        $stderrLines = @()
        if (Test-Path -LiteralPath $stderrPath) {
            $stderrLines = Get-Content -LiteralPath $stderrPath -ErrorAction SilentlyContinue
        }

        if ($exitCode -ne 0) {
            $message = ($stderrLines + $stdoutLines | Where-Object { $_ -ne "" }) -join [Environment]::NewLine
            throw "adb command failed with exit code $exitCode.`n$message"
        }

        return @($stdoutLines)
    } finally {
        Remove-Item -LiteralPath $stdoutPath, $stderrPath -ErrorAction SilentlyContinue
    }
}

function Invoke-AdbShell {
    param([string]$ScriptText)

    return Invoke-AdbCommand -Arguments @("shell", $ScriptText)
}

function Remove-AnsiEscape {
    param([string[]]$Lines)

    $pattern = "\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])"
    return $Lines |
        ForEach-Object { $_ -replace "`r", "" } |
        ForEach-Object { $_ -replace $pattern, "" } |
        ForEach-Object { $_.TrimEnd() } |
        Where-Object { $_ -ne "" }
}

function Remove-KnownNoise {
    param([string[]]$Lines)

    return $Lines | Where-Object {
        $_ -notmatch "Broken pipe" -and
        $_ -notmatch "DUMP TIMEOUT"
    }
}

function Select-FirstNonEmptyLine {
    param([string[]]$Lines)

    foreach ($line in $Lines) {
        if ($line.Trim()) {
            return $line.Trim()
        }
    }
    return ""
}

function Format-FrequencyLines {
    param([string[]]$Lines)

    $formatted = New-Object System.Collections.Generic.List[string]
    foreach ($line in $Lines) {
        if ($line -match "^(cpu\d+)=(\d+)$") {
            $cpu = $matches[1]
            $ghz = [double]$matches[2] / 1000000
            $formatted.Add(("{0}={1:N2}GHz" -f $cpu, $ghz))
        }
    }

    if ($formatted.Count -eq 0) {
        return @("unavailable")
    }

    $grouped = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $formatted.Count; $i += 4) {
        $end = [Math]::Min($i + 3, $formatted.Count - 1)
        $grouped.Add(($formatted[$i..$end] -join "  "))
    }
    return $grouped.ToArray()
}

function Get-CpuUsageLines {
    param([string[]]$Lines)

    $splitIndex = [Array]::IndexOf($Lines, "__CPU_SAMPLE_SPLIT__")
    if ($splitIndex -lt 1 -or $splitIndex -ge ($Lines.Count - 1)) {
        return @("unavailable")
    }

    $first = $Lines[0..($splitIndex - 1)]
    $second = $Lines[($splitIndex + 1)..($Lines.Count - 1)]

    $firstStats = @{}
    foreach ($line in $first) {
        if ($line -notmatch "^(cpu\d+)\s+(.+)$") {
            continue
        }
        $fields = $matches[2] -split "\s+" | Where-Object { $_ -ne "" }
        if ($fields.Count -lt 5) {
            continue
        }
        $numbers = @($fields | ForEach-Object { [double]$_ })
        $firstStats[$matches[1]] = @{
            Total = ($numbers | Measure-Object -Sum).Sum
            Idle  = $numbers[3] + $numbers[4]
        }
    }

    $formatted = New-Object System.Collections.Generic.List[string]
    foreach ($line in $second) {
        if ($line -notmatch "^(cpu\d+)\s+(.+)$") {
            continue
        }
        $cpu = $matches[1]
        if (-not $firstStats.ContainsKey($cpu)) {
            continue
        }

        $fields = $matches[2] -split "\s+" | Where-Object { $_ -ne "" }
        if ($fields.Count -lt 5) {
            continue
        }

        $numbers = @($fields | ForEach-Object { [double]$_ })
        $total = ($numbers | Measure-Object -Sum).Sum
        $idle = $numbers[3] + $numbers[4]
        $totalDelta = $total - $firstStats[$cpu].Total
        $idleDelta = $idle - $firstStats[$cpu].Idle

        if ($totalDelta -le 0) {
            $usage = 0
        } else {
            $usage = (($totalDelta - $idleDelta) / $totalDelta) * 100
        }

        $formatted.Add(("{0}={1,5:N1}%" -f $cpu, $usage))
    }

    if ($formatted.Count -eq 0) {
        return @("unavailable")
    }

    $grouped = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $formatted.Count; $i += 4) {
        $end = [Math]::Min($i + 3, $formatted.Count - 1)
        $grouped.Add(($formatted[$i..$end] -join "  "))
    }
    return $grouped.ToArray()
}

function Get-DeviceValue {
    param([string[]]$Arguments)
    return Select-FirstNonEmptyLine -Lines (Invoke-AdbCommand -Arguments $Arguments)
}

function Get-Snapshot {
    $sampleSeconds = ("{0:0.000}" -f ($CpuSampleMs / 1000.0)).Replace(",", ".")
    $online = Select-FirstNonEmptyLine -Lines (Invoke-AdbShell -ScriptText "cat /sys/devices/system/cpu/online 2>/dev/null || echo unavailable")
    $freqLines = Format-FrequencyLines -Lines (Invoke-AdbShell -ScriptText @'
for f in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
  [ -f "$f" ] || continue
  cpu=$(basename "$(dirname "$(dirname "$f")")")
  value=$(cat "$f" 2>/dev/null || echo "?")
  echo "$cpu=$value"
done
'@)
    $cpuUsageLines = Get-CpuUsageLines -Lines (Invoke-AdbShell -ScriptText @"
grep '^cpu[0-9]' /proc/stat
sleep $sampleSeconds
echo __CPU_SAMPLE_SPLIT__
grep '^cpu[0-9]' /proc/stat
"@)

    $topLines = Remove-AnsiEscape -Lines (Invoke-AdbShell -ScriptText ("TERM=dumb top -n 1 -m {0}" -f $TopRows))
    $cpuInfoLines = Remove-KnownNoise -Lines (Remove-AnsiEscape -Lines (Invoke-AdbShell -ScriptText ("dumpsys cpuinfo | head -n {0}" -f $CpuInfoRows)))
    $memInfoLines = Remove-KnownNoise -Lines (Remove-AnsiEscape -Lines (Invoke-AdbShell -ScriptText ("dumpsys meminfo | head -n {0}" -f $MemInfoRows)))

    return [pscustomobject]@{
        CapturedAt   = Get-Date
        Online       = $online
        Frequencies  = $freqLines
        CpuUsage     = $cpuUsageLines
        TopLines     = $topLines
        CpuInfoLines = @($cpuInfoLines)
        MemInfoLines = @($memInfoLines)
    }
}

function Write-Section {
    param(
        [string]$Title,
        [string[]]$Lines
    )

    Write-Host ("== {0} ==" -f $Title) -ForegroundColor Cyan
    if (-not $Lines -or $Lines.Count -eq 0) {
        Write-Host "unavailable"
    } else {
        foreach ($line in $Lines) {
            Write-Host $line
        }
    }
    Write-Host ""
}

$script:AdbExe = Resolve-AdbPath -RequestedPath $AdbPath
$deviceState = Get-DeviceValue -Arguments @("get-state")
if ($deviceState -ne "device") {
    throw "adb reported state '$deviceState'. Connect a device before running this watcher."
}

$model = Get-DeviceValue -Arguments @("shell", "getprop", "ro.product.model")
$device = Get-DeviceValue -Arguments @("shell", "getprop", "ro.product.device")
$androidVersion = Get-DeviceValue -Arguments @("shell", "getprop", "ro.build.version.release")

do {
    $snapshot = Get-Snapshot

    Clear-Host
    Write-Host "Android ADB Resource Watch" -ForegroundColor Green
    Write-Host ("Captured: {0}" -f $snapshot.CapturedAt.ToString("yyyy-MM-dd HH:mm:ss"))
    Write-Host ("Device: {0} ({1})  Android {2}" -f $model, $device, $androidVersion)
    if ($Serial) {
        Write-Host ("Serial: {0}" -f $Serial)
    }
    Write-Host ("adb: {0}" -f $script:AdbExe)
    Write-Host ("Refresh: {0}s  top rows: {1}" -f $RefreshSeconds, $TopRows)
    Write-Host ("CPU online: {0}" -f $snapshot.Online)
    foreach ($line in $snapshot.CpuUsage) {
        Write-Host ("CPU use:  {0}" -f $line)
    }
    foreach ($line in $snapshot.Frequencies) {
        Write-Host ("CPU freq: {0}" -f $line)
    }
    Write-Host ""

    Write-Section -Title "top" -Lines $snapshot.TopLines
    Write-Section -Title "dumpsys cpuinfo" -Lines $snapshot.CpuInfoLines
    Write-Section -Title "dumpsys meminfo" -Lines $snapshot.MemInfoLines

    if ($Once) {
        break
    }

    Start-Sleep -Seconds $RefreshSeconds
} while ($true)
