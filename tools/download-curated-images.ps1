[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$staticRoot = Join-Path $projectRoot "src\main\resources\static"
$themeRoot = Join-Path $projectRoot "src\main\resources\static\home\public\img\theme"

$headers = @{
  "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0 Safari/537.36"
}

$photoSources = @{
  "trade_show_main" = "https://images.pexels.com/photos/35138560/pexels-photo-35138560.jpeg?cs=srgb&dl=pexels-tahir-35138560.jpg&fm=jpg"
  "trade_show_booth" = "https://images.pexels.com/photos/31311125/pexels-photo-31311125.jpeg?cs=srgb&dl=pexels-gb-the-green-brand-1259697174-31311125.jpg&fm=jpg"
  "trade_show_scandi" = "https://images.pexels.com/photos/31311141/pexels-photo-31311141.jpeg?cs=srgb&dl=pexels-gb-the-green-brand-1259697174-31311141.jpg&fm=jpg"
  "digital_gallery" = "https://images.pexels.com/photos/12740354/pexels-photo-12740354.jpeg?cs=srgb&dl=pexels-lius-hansen-786530-12740354.jpg&fm=jpg"
  "art_gallery_wall" = "https://images.pexels.com/photos/11489982/pexels-photo-11489982.jpeg?cs=srgb&dl=pexels-bertellifotografia-11489982.jpg&fm=jpg"
  "art_exhibit" = "https://images.pexels.com/photos/1604991/pexels-photo-1604991.jpeg?cs=srgb&dl=pexels-sevenstormphotography-1604991.jpg&fm=jpg"
  "fashion_runway" = "https://images.pexels.com/photos/28587831/pexels-photo-28587831.jpeg?cs=srgb&dl=pexels-phamthe-28587831.jpg&fm=jpg"
  "electric_vehicle" = "https://images.pexels.com/photos/14999409/pexels-photo-14999409.jpeg?cs=srgb&dl=pexels-zion-14999409.jpg&fm=jpg"
  "food_festival" = "https://images.pexels.com/photos/28459383/pexels-photo-28459383.png?cs=srgb&dl=pexels-thanh-van-dinh-712218856-28459383.jpg&fm=jpg"
  "history_exhibit" = "https://images.pexels.com/photos/33990550/pexels-photo-33990550.jpeg?cs=srgb&dl=pexels-theshuttervision-33990550.jpg&fm=jpg"
  "industrial_hall" = "https://images.pexels.com/photos/5505930/pexels-photo-5505930.jpeg?cs=srgb&dl=pexels-mike-van-schoonderwalt-1884800-5505930.jpg&fm=jpg"
  "city_skyline" = "https://images.pexels.com/photos/13398543/pexels-photo-13398543.jpeg?cs=srgb&dl=pexels-imagevain-13398543.jpg&fm=jpg"
  "museum_gallery" = "https://images.pexels.com/photos/14595878/pexels-photo-14595878.jpeg?cs=srgb&dl=pexels-jane-bird-380079265-14595878.jpg&fm=jpg"
  "open_exhibition" = "https://images.pexels.com/photos/5505930/pexels-photo-5505930.jpeg?cs=srgb&dl=pexels-mike-van-schoonderwalt-1884800-5505930.jpg&fm=jpg"
}

$targets = @(
  @{ Path = Join-Path $themeRoot "expo-floor.jpg"; Source = "trade_show_main" },
  @{ Path = Join-Path $themeRoot "future-showroom.jpg"; Source = "open_exhibition" },
  @{ Path = Join-Path $themeRoot "city-night.jpg"; Source = "city_skyline" },

  @{ Path = Join-Path $staticRoot "1872560521400549377.jpg"; Source = "trade_show_booth" },
  @{ Path = Join-Path $staticRoot "1872560438676291584.jpg"; Source = "digital_gallery" },
  @{ Path = Join-Path $staticRoot "1872560578883485697.jpg"; Source = "art_gallery_wall" },
  @{ Path = Join-Path $staticRoot "1872561183685345281.jpg"; Source = "city_skyline" },
  @{ Path = Join-Path $staticRoot "1872560483886694400.jpg"; Source = "fashion_runway" },
  @{ Path = Join-Path $staticRoot "1872560415003639808.jpg"; Source = "history_exhibit" },
  @{ Path = Join-Path $staticRoot "1872560464651616256.jpg"; Source = "city_skyline" },
  @{ Path = Join-Path $staticRoot "1872560504107433985.jpg"; Source = "open_exhibition" },
  @{ Path = Join-Path $staticRoot "1872561202530353152.jpg"; Source = "electric_vehicle" },
  @{ Path = Join-Path $staticRoot "1872560538781745153.jpg"; Source = "industrial_hall" },
  @{ Path = Join-Path $staticRoot "1872560848992468993.jpg"; Source = "food_festival" },
  @{ Path = Join-Path $staticRoot "1872560391813332992.jpg"; Source = "trade_show_main" },

  @{ Path = Join-Path $staticRoot "2039526773309308929.jpg"; Source = "trade_show_scandi" },
  @{ Path = Join-Path $staticRoot "2039526783413387265.jpg"; Source = "trade_show_booth" },
  @{ Path = Join-Path $staticRoot "2039526817383055361.jpg"; Source = "art_exhibit" },
  @{ Path = Join-Path $staticRoot "2039526686025842689.jpg"; Source = "city_skyline" },
  @{ Path = Join-Path $staticRoot "2039526725255168000.jpg"; Source = "fashion_runway" },
  @{ Path = Join-Path $staticRoot "2039526792351449089.jpg"; Source = "museum_gallery" },
  @{ Path = Join-Path $staticRoot "2039526695886651392.jpg"; Source = "trade_show_main" },
  @{ Path = Join-Path $staticRoot "2039526705541939200.jpg"; Source = "open_exhibition" },
  @{ Path = Join-Path $staticRoot "2039526857212166145.jpg"; Source = "electric_vehicle" },
  @{ Path = Join-Path $staticRoot "2039526716006727680.jpg"; Source = "industrial_hall" },
  @{ Path = Join-Path $staticRoot "2039526763897290753.jpg"; Source = "food_festival" },
  @{ Path = Join-Path $staticRoot "2039526649506037761.jpg"; Source = "trade_show_main" },

  @{ Path = Join-Path $staticRoot "1878628406896099329.jpg"; Source = "trade_show_booth" },
  @{ Path = Join-Path $staticRoot "1878628467348602881.jpg"; Source = "digital_gallery" },
  @{ Path = Join-Path $staticRoot "1878628479247843328.jpg"; Source = "fashion_runway" },
  @{ Path = Join-Path $staticRoot "1878628380727836673.jpg"; Source = "city_skyline" },
  @{ Path = Join-Path $staticRoot "1878628419307044865.jpg"; Source = "history_exhibit" },
  @{ Path = Join-Path $staticRoot "1878628430526808065.jpg"; Source = "trade_show_main" },
  @{ Path = Join-Path $staticRoot "1878628442086309888.jpg"; Source = "open_exhibition" },
  @{ Path = Join-Path $staticRoot "1878628393314942976.jpg"; Source = "trade_show_scandi" },
  @{ Path = Join-Path $staticRoot "1878628357793382401.jpg"; Source = "electric_vehicle" },
  @{ Path = Join-Path $staticRoot "1878628456632156161.jpg"; Source = "industrial_hall" },
  @{ Path = Join-Path $staticRoot "1878628367985541121.jpg"; Source = "food_festival" },
  @{ Path = Join-Path $staticRoot "1878628346712031232.jpg"; Source = "trade_show_main" },

  @{ Path = Join-Path $staticRoot "1872543800400805888.jpg"; Source = "trade_show_main" },
  @{ Path = Join-Path $staticRoot "1872542688616644609.jpg"; Source = "industrial_hall" },
  @{ Path = Join-Path $staticRoot "1872545320131362817.jpg"; Source = "city_skyline" },
  @{ Path = Join-Path $staticRoot "1872543337374810112.jpg"; Source = "trade_show_main" },
  @{ Path = Join-Path $staticRoot "1872546874641088512.jpg"; Source = "electric_vehicle" },
  @{ Path = Join-Path $staticRoot "1872544538984185857.jpg"; Source = "open_exhibition" }
)

foreach ($target in $targets) {
  $path = $target.Path
  $sourceKey = $target.Source
  $imageUrl = $photoSources[$sourceKey]

  $dir = Split-Path -Path $path -Parent
  if (!(Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
  }

  Write-Host "Downloading $sourceKey -> $path"
  & curl.exe -L --fail --silent --show-error $imageUrl -o $path
  if ($LASTEXITCODE -ne 0) {
    throw "Download failed for $sourceKey"
  }
}

Write-Host "Done."
