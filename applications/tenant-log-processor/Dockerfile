FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS uv-builder

WORKDIR /app

RUN apt-get update && apt-get install -y ca-certificates curl \
    && python -m pip install --upgrade pip


# Copy project metadata files
COPY pyproject.toml uv.lock ./

# Sync dependencies using uv (uv is pre-installed in this image)
RUN uv --version && uv sync --locked 

FROM python:3.13-slim

WORKDIR /app

# Copy installed dependencies from the uv-builder stage
COPY --from=uv-builder /app /app

COPY . .

CMD ["uv", "run", "uvicorn", "app.main:app"]
