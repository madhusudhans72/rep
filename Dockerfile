# Stage 1: Build stage with Ansible
FROM ubuntu:20.04 AS builder
ENV HTTP_PROXY=http://10.158.100.2:8080 
ENV HTTPS_PROXY=http://10.158.100.2:8080
RUN set -x && \
    export HTTP_PROXY=http://10.158.100.2:8080 && \
    export HTTPS_PROXY=http://10.158.100.2:8080 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 \
    python3-pip

# Install Ansible
RUN pip3 install ansible
RUN pip3 install flask
# Stage 2: Runtime stage
FROM python:3.8

# Copy Ansible installation from the builder stage
COPY --from=builder /usr/local/lib/python3.8/dist-packages /usr/local/lib/python3.8/dist-packages
COPY --from=builder /usr/local/bin/ansible* /usr/local/bin/

# Copy your Ansible playbook and related files
COPY nginx_deployment.yaml /ansible/nginx_deployment.yaml
COPY hello.py /ansible/
# Set the working directory
WORKDIR /ansible

# Run the Ansible task
CMD ["ansible-playbook", "nginx_deployment.yaml"]

CMD ["python3", "hello.py"]
