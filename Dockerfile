FROM ubuntu:trusty
MAINTAINER Jay Kline <jay@slushpupie.com>

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y openjdk-7-jdk

# Add pylint
RUN apt-get install -y pylint

# Add user jenkins to the image
RUN useradd -m jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd
# Set public key for the jenkins user to use
RUN mkdir -p ~jenkins/.ssh 
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5d0zLt9brsUL5oCAMOx8XAKhc9E2G4G1ry5eO0kIDI7nNL9AYBaURfS45ta/8hxapnXgF34aVCQHEmw52L15FpSxi8WNNRXRzWbXr/x0gQ79c0c2T6jonekOvYhAOkgwTQkywabilhleeUeP7kFOqHNQPlBBhWGhPVdGPTl0cvdVmbX+C7awCAkf9C3w+XIs8DJDM/cnTIBPaK+xu6nbzbKrr7eR7gFBdUClUjh0Rq3LsRofBmD4ymXV5rrTfudepRn/0ol7C3i0CqEJd5smMyNyPHKLinlZsKONOkGeafZeTixUpkU00fb8njG8BkJpALCKUZ08GPYaBXMCX3uSB jenkins@walnut.slushpupie.com' > ~jenkins/.ssh/authorized_keys
RUN chown -R jenkins:jenkins ~jenkins/.ssh

# Make sure github.com is known
RUN echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> /etc/ssh/ssh_known_hosts

# Install Docker
RUN apt-get -y install curl
RUN curl -sSL https://get.docker.com/ | sh

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]


