$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$targetDir = Join-Path $projectRoot "src\main\resources\static"

$imageMap = @(
    @{ File = "2039516678517161985.jpg"; PhotoId = "HgiU4c7dUNA" },
    @{ File = "2039516689392992257.jpg"; PhotoId = "R_dV4mENlSc" },
    @{ File = "2039516604873572353.jpg"; PhotoId = "86QLk_86JRk" },

    @{ File = "1872560521400549377.jpg"; PhotoId = "dGgQNyB63tw" },
    @{ File = "1872560438676291584.jpg"; PhotoId = "R_dV4mENlSc" },
    @{ File = "1872560578883485697.jpg"; PhotoId = "86QLk_86JRk" },
    @{ File = "1872561183685345281.jpg"; PhotoId = "pwv04Th9qRg" },
    @{ File = "1872560483886694400.jpg"; PhotoId = "47mWzYUe-sA" },
    @{ File = "1872560415003639808.jpg"; PhotoId = "yjZSIfCnxkI" },
    @{ File = "1872560464651616256.jpg"; PhotoId = "HgiU4c7dUNA" },
    @{ File = "1872560504107433985.jpg"; PhotoId = "rngipgK6gDo" },
    @{ File = "1872561202530353152.jpg"; PhotoId = "6fizkg4RyPc" },
    @{ File = "1872560538781745153.jpg"; PhotoId = "dGgQNyB63tw" },
    @{ File = "1872560848992468993.jpg"; PhotoId = "gDgYZLiZflc" },
    @{ File = "1872560391813332992.jpg"; PhotoId = "86QLk_86JRk" },

    @{ File = "1872543800400805888.jpg"; PhotoId = "jSniVrdhDtc" },
    @{ File = "1872542688616644609.jpg"; PhotoId = "rngipgK6gDo" },
    @{ File = "1872545320131362817.jpg"; PhotoId = "R_dV4mENlSc" },
    @{ File = "1872543337374810112.jpg"; PhotoId = "nPnDIbNuLhw" },
    @{ File = "1872546874641088512.jpg"; PhotoId = "6fizkg4RyPc" },
    @{ File = "1872544538984185857.jpg"; PhotoId = "gDgYZLiZflc" }
)

$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36"
}

foreach ($item in $imageMap) {
    $downloadUrl = "https://unsplash.com/photos/$($item.PhotoId)/download?force=true&w=1800&q=80"
    $targetPath = Join-Path $targetDir $item.File
    Invoke-WebRequest -Uri $downloadUrl -Headers $headers -OutFile $targetPath
}

Write-Output ("Downloaded {0} curated gallery images to {1}" -f $imageMap.Count, $targetDir)
