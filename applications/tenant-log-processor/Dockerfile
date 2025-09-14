FROM python:3.13

# Install curl (required to install uv)
RUN apt-get update && apt-get install -y curl

# Install uv (https://astral.sh/uv)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set working directory
WORKDIR /app

# Copy project metadata files
COPY pyproject.toml uv.lock ./

# Install production dependencies
RUN uv --version && uv sync --locked --no-group dev

# Copy application source code
COPY . .

# Expose the application port

# Run the FastAPI application using uv
CMD ["uv", "run", "uvicorn", "main:app"]