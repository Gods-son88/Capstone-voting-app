# ==========================================
# 1. Base Stage: Core Runtime & Dependencies
# ==========================================
FROM python:3.11-slim AS base

# Add curl cleanly for automated healthcheck parameters
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

# Install our requirements.txt with absolute caching prevention
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# ==========================================
# 2. Dev Stage: Local Development Sandbox
# ==========================================
FROM base AS dev
RUN pip install watchdog
ENV FLASK_ENV=development
CMD ["python", "app.py"]


# ==========================================
# 3. Final Stage: Secure Production Build
# ==========================================
FROM base AS final

# Copy code into our designated working environment
COPY . .

# Create a secure, low-privilege application system user
RUN useradd -u 10001 appuser && chown -R appuser:appuser /usr/local/app

# Drop root context and enforce standard user constraints
USER appuser

EXPOSE 80

# Execute high-concurrency production gunicorn engine safely
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:80", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]

