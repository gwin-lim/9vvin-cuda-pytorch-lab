# 9vvin jupyter notebook container

## description

내가 쓰기 편하려고 만든 주피터 노트북 환경

- cuda
- cdnn
- pytorch

더 자세한 스펙은 Dockerfile 참조 바람.

## environment variables

빌드, 런 명령 실행시 사용.

```.env
EXPOSE_PORT=8888
WORKDIR=/workspace
SHM_SIZE=32g
HOST_VOL=workspace_vol
IMG_REPO_NAME=my-docker-repo
IMG_NAME=cuda-torch-lab
HOST_PORT=8888
IMG_VER=v1.0
```

## build image (bash)

```bash
export $(cat .env | xargs) && \
export IMG_VER="$(git describe --tags --always)" && \
export IMG_TAG="$IMG_NAME:$IMG_VER" && \
docker build \
  --build-arg EXPOSE_PORT \
  --build-arg WORKDIR \
  --build-arg SHM_SIZE \
  -t $IMG_TAG .
```

## build image (power shell)

```pwsh
$env:EXPOSE_PORT = (Get-Content .env | Where-Object { $_ -match "^EXPOSE_PORT=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:WORKDIR = (Get-Content .env | Where-Object { $_ -match "^WORKDIR=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:SHM_SIZE = (Get-Content .env | Where-Object { $_ -match "^SHM_SIZE=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:IMG_REPO_NAME = (Get-Content .env | Where-Object { $_ -match "^IMG_REPO_NAME=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:IMG_NAME = (Get-Content .env | Where-Object { $_ -match "^IMG_NAME=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:IMG_VER = (git describe --tags --always) ; `
$env:IMG_TAG = "$env:IMG_REPO_NAME/$env:IMG_NAME`:$env:IMG_VER" ; `
docker build `
  --build-arg EXPOSE_PORT=$env:EXPOSE_PORT `
  --build-arg WORKDIR=$env:WORKDIR `
  --build-arg SHM_SIZE=$env:SHM_SIZE `
  -t $env:IMG_TAG .
```

## run container (bash)

```bash
export $(cat .env | xargs) && \
export IMG_VER="$(git describe --tags --always)" && \
export IMG_TAG="$IMG_NAME:$IMG_VER" && \
docker run -it --rm --gpus all \
  -p "$HOST_PORT:$EXPOSE_PORT" \
  -v "$(pwd)/$HOST_VOL:$WORKDIR" \
  --name $IMG_NAME \
  $IMG_TAG
```

## run container (power shell)

```pwsh
$env:EXPOSE_PORT = (Get-Content .env | Where-Object { $_ -match "^EXPOSE_PORT=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:HOST_PORT = (Get-Content .env | Where-Object { $_ -match "^HOST_PORT=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:HOST_VOL = (Get-Content .env | Where-Object { $_ -match "^HOST_VOL=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:WORKDIR = (Get-Content .env | Where-Object { $_ -match "^WORKDIR=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:IMG_REPO_NAME = (Get-Content .env | Where-Object { $_ -match "^IMG_REPO_NAME=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:IMG_NAME = (Get-Content .env | Where-Object { $_ -match "^IMG_NAME=" } | ForEach-Object { $_.Split('=')[1].Trim() }) ; `
$env:IMG_VER = (git describe --tags --always) ; `
$env:IMG_TAG = "$env:IMG_REPO_NAME/$env:IMG_NAME`:$env:IMG_VER" ; `
$env:HOST_VOL_ABS = "$(pwd)\$env:HOST_VOL" ; `
docker run -d --gpus all `
  -p $env:HOST_PORT`:$env:EXPOSE_PORT `
  -v $env:HOST_VOL_ABS`:$env:WORKDIR `
  --name $env:IMG_NAME `
  $env:IMG_TAG
```
