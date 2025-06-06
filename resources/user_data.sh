#!/bin/bash
exec > /var/log/user-data.log 2>&1
echo Running user-data script
echo enabling SSM Agent
# https://repost.aws/knowledge-center/install-ssm-agent-ec2-linux
dnf update -y && sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

echo Adding github_runner user
useradd -m github_runner

echo installing Docker
dnf -y install docker
systemctl enable docker
service docker start
usermod -a -G docker github_runner

echo install Java
dnf -y install java-11-amazon-corretto-devel

echo install maven
dnf -y install maven

echo Starting GitHub Self-Hosted Runner
dnf update && dnf install libicu -y
# Create a folder
su -c "mkdir ~/actions-runner" github_runner
# Here we 'cd' as root so that all the 'su'-based commands execute in the correct directory
cd ~github_runner/actions-runner
# Download the latest runner package
su -c "curl -o ./actions-runner-linux-arm64-2.324.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.324.0/actions-runner-linux-arm64-2.324.0.tar.gz" github_runner
# Extract the installer
su -c "tar xzf ./actions-runner-linux-arm64-2.324.0.tar.gz" github_runner
# Create the runner and start the configuration experience
su -c "./config.sh --unattended --replace --url {github_repo_url} --token {github_runner_token} --labels {runner_label}" github_runner
# from https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service
# Install the service with the following command:
./svc.sh install github_runner
# Start the service with the following command:
./svc.sh start

echo User-data script completed.
