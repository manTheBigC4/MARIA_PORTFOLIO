Add-Type -AssemblyName System.Drawing

function Optimize-Image($srcPath, $dstPath, $maxDim, $quality) {
    $dir = Split-Path $dstPath -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    
    $resolved = (Resolve-Path $srcPath).Path
    $src = [System.Drawing.Image]::FromFile($resolved)
    $w = $src.Width
    $h = $src.Height
    
    $scale = 1.0
    if ($w -gt $maxDim -or $h -gt $maxDim) {
        $scale = [Math]::Min([double]$maxDim / $w, [double]$maxDim / $h)
    }
    
    $newW = [int]($w * $scale)
    $newH = [int]($h * $scale)
    
    $bmp = New-Object System.Drawing.Bitmap($newW, $newH)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    
    $g.DrawImage($src, 0, 0, $newW, $newH)
    $src.Dispose()
    $g.Dispose()
    
    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
    
    $bmp.Save($dstPath, $codec, $encoderParams)
    $bmp.Dispose()
    $encoderParams.Dispose()
    
    $sz = [int]((Get-Item $dstPath).Length / 1024)
    $fileName = Split-Path $dstPath -Leaf
    Write-Host "Optimized: $fileName -> ${newW}x${newH} ($sz KB)"
}

# 1. Floral series
Optimize-Image "assets/raw_photos/intro.jpg" "assets/gallery/floral/01_canna_lily.jpg" 1400 90
Optimize-Image "assets/raw_photos/2.jpg" "assets/gallery/floral/02_peregrina.jpg" 1400 90
Optimize-Image "assets/raw_photos/3.jpg" "assets/gallery/floral/03_snapdragon.jpg" 1400 90
Optimize-Image "assets/raw_photos/4.jpg" "assets/gallery/floral/04_mums.jpg" 1400 90
Optimize-Image "assets/raw_photos/5.jpg" "assets/gallery/floral/05_red_frangipani.jpg" 1400 90
Optimize-Image "assets/raw_photos/6.jpg" "assets/gallery/floral/06_plumeria_alba.jpg" 1400 90
Optimize-Image "assets/raw_photos/7.jpg" "assets/gallery/floral/07_purple_hibiscus.jpg" 1400 90
Optimize-Image "assets/raw_photos/8.jpg" "assets/gallery/floral/08_pansy.jpg" 1400 90
Optimize-Image "assets/raw_photos/9.jpg" "assets/gallery/floral/09_alstroemeria_psittacina.jpg" 1400 90
Optimize-Image "assets/raw_photos/10.jpg" "assets/gallery/floral/10_desert_rose.jpg" 1400 90
Optimize-Image "assets/raw_photos/11.jpg" "assets/gallery/floral/11_crossandra_infundibuliformis.jpg" 1400 90
Optimize-Image "assets/raw_photos/12.jpg" "assets/gallery/floral/12_turnera_ulmifolia.jpg" 1400 90
Optimize-Image "assets/raw_photos/13.jpg" "assets/gallery/floral/13_asystasia.jpg" 1400 90
Optimize-Image "assets/raw_photos/14.jpg" "assets/gallery/floral/14_crown_of_thorns.jpg" 1400 90
Optimize-Image "assets/raw_photos/final.jpg" "assets/gallery/floral/15_variegated_pineapple_lily.jpg" 1400 90

# 2. Mina series
Optimize-Image "assets/raw_op/mina/extracted_mina_1.jpg" "assets/gallery/mina/01_ang_jam.jpg" 1400 90
Optimize-Image "assets/raw_op/mina/20260222_011928.jpg" "assets/gallery/mina/02_katutubong_paghabi.jpg" 1400 90
Optimize-Image "assets/raw_op/Ortigas Art Frstival/20260703_042436.jpg" "assets/gallery/mina/03_infinite_waterfalls.jpg" 1400 90
Optimize-Image "assets/raw_photos/ang kalachuchi.jpg" "assets/gallery/mina/04_dilaw_na_kalachuchi.jpg" 1400 90
Optimize-Image "assets/raw_op/Ortigas Art Frstival/20260703_042619.jpg" "assets/gallery/mina/05_mt_halcon_coffee.jpg" 1400 90

# 3. Ortigas & Major Exhibitions
Optimize-Image "assets/raw_op/Ortigas Art Frstival/ilocos lighthouse.jpg" "assets/gallery/exhibitions/light_tower_ilocos.jpg" 1400 90

# 4. Landscapes & Botanical
Optimize-Image "assets/raw_photos/ls 20.jpg" "assets/gallery/botanical_landscape/01_cattleya_orchid.jpg" 1400 90
Optimize-Image "assets/raw_photos/ls 23.jpg" "assets/gallery/botanical_landscape/02_bougainvillea.jpg" 1400 90
Optimize-Image "assets/raw_photos/ls 25.jpg" "assets/gallery/botanical_landscape/03_sampaguita.jpg" 1400 90
Optimize-Image "assets/raw_photos/ls 27.jpg" "assets/gallery/botanical_landscape/04_desert_rose_blossom.jpg" 1400 90
Optimize-Image "assets/raw_photos/ls 33.jpg" "assets/gallery/botanical_landscape/05_sunflower.jpg" 1400 90
