# Base image optimized for Python applications
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies and cleanup in one layer to keep image size small
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create requirements.txt if it doesn't exist
RUN echo "qrcode\npillow" > default_requirements.txt

# Copy requirements.txt if it exists, otherwise use default
COPY requirements.txt* ./
RUN if [ -f requirements.txt ]; then \
    pip install --no-cache-dir -r requirements.txt; \
    else \
    pip install --no-cache-dir -r default_requirements.txt; \
    fi

# Copy application code
COPY . .

# Conditionally install npm dependencies if package.json exists
RUN if [ -f package.json ]; then \
    npm install; \
    else \
    echo "No package.json found. Skipping npm install."; \
    fi

# Create a non-root user for better security
RUN useradd -m appuser
RUN chown -R appuser:appuser /app
USER appuser

# Expose the port your application uses
EXPOSE 8080

# Command to run the application
CMD ["python", "main.py"]