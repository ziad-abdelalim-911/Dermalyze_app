# ============================================================
#  start_emulator_centered.ps1
#  Launches Android Emulator and centers it on screen
# ============================================================

$EmulatorExe = "D:\AndroidSdk\Sdk\emulator\emulator.exe"
$AvdName = "Pixel_10_Pro"

# -- Win32 API to read and move windows -----------------------
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class WinAPI {
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern int GetSystemMetrics(int nIndex);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int Left, Top, Right, Bottom;
    }
}
"@

# -- Launch emulator in background ----------------------------
Write-Host "[*] Launching emulator: $AvdName ..." -ForegroundColor Cyan
$proc = Start-Process -FilePath $EmulatorExe `
                      -ArgumentList "-avd", $AvdName, "-scale", "0.5" `
                      -WindowStyle Normal `
                      -PassThru

# -- Wait for emulator window to appear -----------------------
Write-Host "[*] Waiting for emulator window..." -ForegroundColor Yellow

$emulatorHwnd = [IntPtr]::Zero
$timeout      = 120
$elapsed      = 0

while ($elapsed -lt $timeout) {
    Start-Sleep -Seconds 2
    $elapsed += 2

    $procs = Get-Process -ErrorAction SilentlyContinue | Where-Object {
        $_.MainWindowHandle -ne [IntPtr]::Zero -and
        ($_.ProcessName -like "*emulator*" -or $_.ProcessName -like "*qemu*")
    }

    foreach ($p in $procs) {
        $hwnd = $p.MainWindowHandle
        if ($hwnd -ne [IntPtr]::Zero) {
            $sb = New-Object System.Text.StringBuilder 256
            [WinAPI]::GetWindowText($hwnd, $sb, 256) | Out-Null
            $title = $sb.ToString()

            if ([WinAPI]::IsWindowVisible($hwnd)) {
                Write-Host "    Found window: '$title'" -ForegroundColor DarkGray
                $emulatorHwnd = $hwnd
                break
            }
        }
    }

    if ($emulatorHwnd -ne [IntPtr]::Zero) { break }
    Write-Host "    Still waiting... ($elapsed s)" -ForegroundColor DarkGray
}

if ($emulatorHwnd -eq [IntPtr]::Zero) {
    Write-Host "[!] Could not find emulator window after $timeout seconds." -ForegroundColor Red
    exit 1
}

# -- Extra wait for window to fully render --------------------
Write-Host "[*] Window found! Waiting for it to fully load..." -ForegroundColor Yellow
Start-Sleep -Seconds 4

# -- Resize & center the emulator window ----------------------
$screenW = [WinAPI]::GetSystemMetrics(0)   # SM_CXSCREEN
$screenH = [WinAPI]::GetSystemMetrics(1)   # SM_CYSCREEN

$rect = New-Object WinAPI+RECT
[WinAPI]::GetWindowRect($emulatorHwnd, [ref]$rect) | Out-Null

$winW = $rect.Right  - $rect.Left
$winH = $rect.Bottom - $rect.Top

# Scale down to 65% of screen height (keeps aspect ratio)
$targetH = [int]($screenH * 0.90)
$ratio    = $targetH / $winH
$targetW  = [int]($winW * $ratio)

# Center on screen
$newX = [int](($screenW - $targetW) / 2)
$newY = [int](($screenH - $targetH) / 2)

if ($newX -lt 0) { $newX = 0 }
if ($newY -lt 0) { $newY = 0 }

Write-Host "[+] Screen   : ${screenW} x ${screenH}" -ForegroundColor Green
Write-Host "[+] Original : ${winW} x ${winH}" -ForegroundColor Green
Write-Host "[+] Resized  : ${targetW} x ${targetH}" -ForegroundColor Cyan
Write-Host "[+] Position : ($newX, $newY)" -ForegroundColor Cyan

[WinAPI]::MoveWindow($emulatorHwnd, $newX, $newY, $targetW, $targetH, $true) | Out-Null
[WinAPI]::SetForegroundWindow($emulatorHwnd) | Out-Null

Write-Host "[OK] Emulator resized and centered!" -ForegroundColor Green
