ARG BASE_IMAGE=dhi.io/python:3.13-alpine

FROM ${BASE_IMAGE}-dev AS builder
WORKDIR /work
COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir --target=/work/deps -r requirements.txt

FROM ${BASE_IMAGE}
ARG RELAY_VERSION
LABEL org.opencontainers.image.source="https://github.com/matonb/smtp-oauth-relay" \
      org.opencontainers.image.version="$RELAY_VERSION"
WORKDIR /app
COPY --from=builder /work/deps /app/deps
COPY src/*.py ./
ENV PYTHONPATH=/app/deps
EXPOSE 8025
CMD ["python3", "main.py"]
