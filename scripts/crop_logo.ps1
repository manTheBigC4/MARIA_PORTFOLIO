Add-Type -AssemblyName System.Drawing
$baseDir = Split-Path -Parent $PSScriptRoot
$srcPath = Join-Path $baseDir "assets\logo.jpg"
$dstPath = Join-Path $baseDir "assets\logo_badge.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
$src = New-Object System.Drawing.Bitmap($img)

$minX = 187; $maxX = 705; $minY = 233; $maxY = 365
$w = $maxX - $minX + 1
$h = $maxY - $minY + 1

$cropped = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $c = $src.GetPixel($minX + $x, $minY + $y)
        # If pixel is near white, make transparent with alpha blending
        if ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240) {
            $cropped.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
        } else {
            $cropped.SetPixel($x, $y, $c)
        }
    }
}

$cropped.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
$cropped.Dispose()
$src.Dispose()
$img.Dispose()
Write-Host "Saved $dstPath ($w x $h)"
