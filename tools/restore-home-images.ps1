$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceDir = Join-Path $projectRoot "frontend\home\public\img"
$targetDir = Join-Path $projectRoot "src\main\resources\static"

$sourceFiles = @(
    "earth.jpeg",
    "bg11.jpg",
    "body_bg.jpg",
    "fire.jpeg",
    "login_img.jpg",
    "dati_img.jpg",
    "bg-1.jpg",
    "7530f6ca-fe64-4024-8947-815daf3a5d4f.jpg",
    "auth_bg.jpeg",
    "user_bg.jpg"
)

$targetFiles = @(
    "2039516678517161985.jpg",
    "2039516689392992257.jpg",
    "2039516604873572353.jpg",
    "1872560521400549377.jpg",
    "1872560438676291584.jpg",
    "1872560578883485697.jpg",
    "1872561183685345281.jpg",
    "1872560483886694400.jpg",
    "1872560415003639808.jpg",
    "1872560464651616256.jpg",
    "1872560504107433985.jpg",
    "1872561202530353152.jpg",
    "1872560538781745153.jpg",
    "1872560848992468993.jpg",
    "1872560391813332992.jpg",
    "1872543800400805888.jpg",
    "1872542688616644609.jpg",
    "1872545320131362817.jpg",
    "1872543337374810112.jpg",
    "1872546874641088512.jpg",
    "1872544538984185857.jpg",
    "2039526773309308929.jpg",
    "2039526783413387265.jpg",
    "2039526817383055361.jpg",
    "2039526686025842689.jpg",
    "2039526725255168000.jpg",
    "2039526792351449089.jpg",
    "2039526695886651392.jpg",
    "2039526705541939200.jpg",
    "2039526857212166145.jpg",
    "2039526716006727680.jpg",
    "2039526763897290753.jpg",
    "2039526649506037761.jpg",
    "1878628406896099329.jpg",
    "1878628467348602881.jpg",
    "1878628479247843328.jpg",
    "1878628380727836673.jpg",
    "1878628419307044865.jpg",
    "1878628430526808065.jpg",
    "1878628442086309888.jpg",
    "1878628393314942976.jpg",
    "1878628357793382401.jpg",
    "1878628456632156161.jpg",
    "1878628367985541121.jpg",
    "1878628346712031232.jpg"
)

foreach ($sourceFile in $sourceFiles) {
    $sourcePath = Join-Path $sourceDir $sourceFile
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        throw "Missing source image: $sourcePath"
    }
}

for ($i = 0; $i -lt $targetFiles.Count; $i++) {
    $sourcePath = Join-Path $sourceDir $sourceFiles[$i % $sourceFiles.Count]
    $targetPath = Join-Path $targetDir $targetFiles[$i]
    Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
}

Write-Output ("Restored {0} upload images into {1}" -f $targetFiles.Count, $targetDir)
