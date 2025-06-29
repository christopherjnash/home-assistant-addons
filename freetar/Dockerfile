FROM python:3.11-alpine

ENV PYTHONUNBUFFERED=TRUE \
    PORT=22201 \
    HOST=0.0.0.0

RUN adduser -D freetar && \
    pip install --no-cache-dir freetar==0.14.0

USER freetar
EXPOSE 22201

CMD ["sh", "-c", "waitress-serve --listen=${HOST}:${PORT} freetar.backend:app"]
