# CUDA 12.6 및 cuDNN 9을 포함한 NVIDIA 공식 이미지 사용
FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04

# 기본 ARG 설정 (호스트에서 전달 가능)
ARG EXPOSE_PORT=8888
ARG WORKDIR=/workspace

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
ENV WORKDIR=$WORKDIR
ENV EXPOSE_PORT=$EXPOSE_PORT

# 작업 디렉토리 생성
WORKDIR $WORKDIR

# 필수 패키지 설치 및 Python 환경 설정
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    git curl wget vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 최신 pip, setuptools, wheel 업그레이드
RUN pip3 install --upgrade pip setuptools wheel

# PyTorch 및 기타 필수 패키지 설치
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

# 추가 Python 라이브러리 설치
RUN pip3 install jupyterlab numpy pandas matplotlib tiktoken

# JupyterLab 실행을 위한 포트 설정
EXPOSE $EXPOSE_PORT

# 컨테이너 실행 시 JupyterLab 시작
CMD ["sh", "-c", "jupyter lab --ip=0.0.0.0 --port=$EXPOSE_PORT --allow-root --no-browser"]
