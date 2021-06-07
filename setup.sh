#!/bin/bash

# This script is designed to set up a useful dev environment, with many 
# different dev utilities. It is tested on Ubuntu Groovy64 only.

PATH_ADD=/usr/local/go/bin:/home/linuxbrew/.linuxbrew/bin


# Install apt packages
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y \
    apt-transport-https \
    aptitude \
    bash-completion \
    bzr-builddeb  \
    ca-certificates \
    curl \
    dh-make \
    exuberant-ctags \
    fzf \
    ghc \
    git \
    gnupg \
    jupyter \
    locate \
    lsb-release \
    lsb-release \
    npm \
    pandoc \
    pip \
    plantuml \
    postgresql \
    rpm \
    shellcheck \
    sqlite3 \
    taskwarrior \
    timewarrior \
    tmux \
    unzip \
    vim \
    virtualbox \
    zip \
    zsh
sudo apt-get install build-essential
sudo snap install rustup --classic

# Update PATH
echo export PATH=\$PATH:$PATH_ADD >> ~/.bashrc
echo export PATH=\$PATH:$PATH_ADD >> ~/.zshrc

# Make sure Taskwarrior data is stored outside the VM
echo "data.location=~/work/.task" >> ~/.taskrc
mkdir -p ~/work/timewarrior
ln -s /home/vagrant/.timewarrior ~/work/timewarrior

# Install official Docker
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod a+rx /usr/local/bin/docker-compose

# Install Golang
sudo wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz

# Add
# protoc-gen-go-, grpcui, gosec, gohack


# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo export PATH=$PATH:/home/vagrant/bin:/usr/local/go/bin >> ~/.zshrc
echo export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin >> ~/.zshrc
sudo chsh vagrant -s /usr/bin/zsh

# Install Docker (official source)
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce 


# Install Terraform and Vagrant
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y terraform vagrant
 
# Install Kind 
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/bin

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/bin/
echo 'alias k=kubectl' >>~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc

# Install K9s
mkdir tmp
pushd tmp
git clone https://github.com/derailed/k9s
cd k9s
make build
popd
sudo rm -rfv temp

# Install Helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install GCP
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install -y apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install -y google-cloud-sdk


# Install VSCode Server
curl -fsSL https://code-server.dev/install.sh | sh
#sed -i.bak 's/auth: password/auth: none/' ~/.config/code-server/config.yaml
sed -i.bak 's/bind-addr: 127.0.0.1:8080/bind-addr: 0.0.0.0:8080/' ~/.config/code-server/config.yaml
sudo systemctl enable --now code-server@vagrant
sleep 1
sudo cp ~/.config/code-server/config.yaml ~/devbox-output/code-server-password.yaml

# Install useful extensions for Code
code-server --install-extension golang.go
code-server --install-extension ms-python.python
code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code-server --install-extension jebbs.plantuml
code-server --install-extension dbankier.vscode-instant-markdown
code-server --install-extension redhat.vscode-yaml
code-server --install-extension hashicorp.terraform
code-server --install-extension rust-lang.rust
code-server --install-extension alanz.vscode-hie-server
code-server --install-extension knisterpeter.vscode-github

# Install Homebrew
echo "\n" | sudo -u vagrant /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vagrant/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew tap thoughtbot/formulae

brew install mutagen
brew install rcm
brew install gh
brew install hugo

# OPA is just a binary
curl -L -o opa https://openpolicyagent.org/downloads/v0.28.0/opa_linux_amd64

# Set up github plugin
gh auth login --hostname github.com --with-token <~/.github-credentials

# Setup dotfiles
git clone git://github.com/dfeldman/dotfiles.git ~/dotfiles

# Install Ansible
sudo python3 -m pip install ansible --user ansible
sudo python3 -m pip install --user paramiko

# Install Exercism (code practice program)
sudo snap install exercism

# Install GetEnvoy
curl -L https://getenvoy.io/cli | sudo bash -s -- -b /usr/local/bin

# Install git-secrets globally
brew install git-secrets
git secrets --install ~/.git-templates/git-secrets
git config --global init.templateDir ~/.git-templates/git-secrets

# Update locate db
sudo updatedb

# Need to re-login
sudo usermod -a -G docker vagrant
newgrp docker

# TODO Add some git plugins
# Make the dotfiles actually work
# Forward more ports for web apps / grpc
# Set up envoy with getenvoy
# Add exercism
# Mongodb
# Script to set it up with Terraform 
# Gosec
# Staticcheck
# TLA/Alloy
# Elm

