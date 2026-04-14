#!/bin/bash
set -e

echo "Updating system..."
yum update -y

echo "Installing Java 17..."
yum install -y java-17-amazon-corretto

echo "Adding Jenkins repo..."
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Installing Jenkins..."
yum install -y jenkins

echo "Starting Jenkins..."
systemctl daemon-reexec
systemctl start jenkins
systemctl enable jenkins

echo "Opening port 8080..."
systemctl status firewalld >/dev/null 2>&1 && \
firewall-cmd --permanent --add-port=8080/tcp && firewall-cmd --reload || echo "No firewall"

echo "Jenkins URL: http://<your-ec2-public-ip>:8080"
echo "Admin Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword
