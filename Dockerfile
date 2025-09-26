FROM ghcr.io/pomo-mondreganto/neo_env:latest

COPY requirements.txt /.
RUN apt update -y && apt install -y tesseract-ocr

RUN python3.9 -m pip install --no-cache -r /requirements.txt