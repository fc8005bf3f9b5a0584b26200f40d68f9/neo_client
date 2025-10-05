FROM sagemath/sagemath:latest

COPY requirements.txt /.

USER root

# Instalar herramientas útiles
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libssl-dev \
    curl \
    iputils-ping \
    netcat-traditional \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

RUN apt update -y && apt install -y tesseract-ocr

RUN apt-get update && apt-get install -y dbus && rm -rf /var/lib/apt/lists/* \
 && dbus-uuidgen > /etc/machine-id

USER sage

RUN sage --pip install --no-cache -r /requirements.txt

ENV PATH="/work/neo_client:${PATH}"
