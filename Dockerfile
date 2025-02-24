# Use a more specific Python version and slim variant for smaller image size
FROM python:3.8-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# Create and set working directory
WORKDIR /app

# Install system dependencies and cleanup in the same layer
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY src/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy source code and install package
COPY src/ src/
WORKDIR /app/src
RUN python setup.py build_ext \
    && python setup.py install

# Copy tests
COPY tests/ /app/tests/

# Expose port
EXPOSE 8000

# Set final working directory
WORKDIR /app/src
