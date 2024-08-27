# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set environment variables to avoid buffering
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /strangerchatbot

# Install system dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libpq-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy only the requirements file first for better cache usage
COPY strangerchatbot/requirements.txt /strangerchatbot/

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the rest of the application code
COPY strangerchatbot /strangerchatbot

# Ensure the wait-for-it script is included and executable
COPY strangerchatbot/wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Define the default command
CMD ["wait-for-it.sh", "postgres:5432", "--", "python3", "app.py"]
