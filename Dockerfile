FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git vim build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes


# Create user Siddarth with sudo privileges
FROM base AS siddarth
RUN addgroup --gid 1000 siddarth
RUN adduser --gecos siddarth --uid 1000 --gid 1000 --disabled-password siddarth

FROM base AS prime
ARG TAGS
RUN addgroup --gid 1000 siddarth
RUN adduser --gecos siddarth --uid 1000 --gid 1000 --disabled-password siddarth
USER siddarth
WORKDIR /home/siddarth

# Final stage to copy files and run your Ansible playbook
FROM siddarth
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

