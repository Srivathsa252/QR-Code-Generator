FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# If you need Node.js as well
RUN apt-get update && apt-get install -y nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy JavaScript files and install npm dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port if your app serves on a web port
EXPOSE 8080

# Command to run the application
CMD ["python", "main.py"]