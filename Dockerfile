# Use the official Python 3.9 image with Alpine Linux 3.13 as the base image
FROM python:3.9-alpine3.13

# Metadata indicating the maintainer's information
LABEL maintainer="Akin125 philipoluseyi@gmail.com"

# Set the PYTHONUNBUFFERED environment variable to ensure Python prints directly to the console without buffering
ENV PYTHONUNBUFFERED 1

# Copy the requirements.txt file from the host machine to the /tmp directory in the image
COPY ./requirements.txt /tmp/requirements.txt

# Copy the entire app directory from the host machine to the /app directory in the image
COPY ./app /app

# Set the working directory for subsequent instructions to /app
WORKDIR /app

# Inform Docker that the container will listen on port 8000 at runtime
EXPOSE 8000

# Run commands to set up the environment:
# - Create a virtual environment in the /py directory
# - Upgrade pip in the virtual environment
# - Install Python packages listed in requirements.txt in the virtual environment
# - Remove the temporary directory /tmp
# - Add a user named django-user without a password and without a home directory
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Add /py/bin directory to the PATH environment variable
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user django-user for improved security
USER django-user