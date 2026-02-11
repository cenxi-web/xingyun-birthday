FROM python:3.12-slim

# Install uv directly from its official image
COPY --from=ghcr.io/astral-sh/uv:0.9.26 /uv /bin/uv

# Set the working directory inside the container
WORKDIR /app

# Copy dependency files first.
# This allows Docker to cache the installed packages layer.
# If you change your code but not your dependencies, this step will be skipped.
COPY pyproject.toml uv.lock ./

# Install dependencies into the system python environment.
RUN uv sync --frozen --no-dev

# This makes 'gunicorn' and 'flask' available globally in the container
ENV PATH="/app/.venv/bin:$PATH"

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Run the production server
# Render provides PORT at runtime; fall back to 5000 for local Docker.
CMD ["sh", "-c", "gunicorn -w 2 -b 0.0.0.0:${PORT:-5000} application:app"]
