FROM python:3.13-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

ARG USER_UID=1000
ARG USER_GID=1000

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    RAZTODO_DB=/data/tasks.db \
    PATH="/app/.venv/bin:$PATH"

WORKDIR /app

COPY . .

RUN uv sync --frozen --no-dev --no-editable

RUN groupadd --gid "$USER_GID" raztodo \
    && useradd \
        --uid "$USER_UID" \
        --gid "$USER_GID" \
        --create-home \
        --shell /usr/sbin/nologin \
        raztodo \
    && mkdir -p /data \
    && chown -R "$USER_UID":"$USER_GID" /data

VOLUME ["/data"]

USER raztodo

ENTRYPOINT ["rt"]