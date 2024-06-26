#!/usr/bin/env bash
# kuberverse k8s lab provisioner
# type: kubeadm-calico-full-cluster-bootstrap
# Credit goes to Artur Scheiner - artur.scheiner@gmail.com

#variable definitions
KVMSG=$1

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Adding Kubernetes and Docker-CE Repo"
echo "********** $KVMSG"
echo "********** $KVMSG"
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common

### Add Kubernetes GPG key
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -


### Kubernetes Repo
echo "deb  http://apt.kubernetes.io/  kubernetes-$(lsb_release -cs)  main" > /etc/apt/sources.list.d/kubernetes.list


### Add Docker’s official GPG key
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg


### Add Docker apt repository.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Updating Repositories"
echo "********** $KVMSG"
echo "********** $KVMSG"
apt-get update

echo "********** $KVMSG"
echo "********** $KVMSG"
echo "********** $KVMSG ->> Installing Required & Recommended Packages"
echo "********** $KVMSG"
echo "********** $KVMSG"
apt-get install -y avahi-daemon libnss-mdns traceroute htop httpie bash-completion docker-ce docker-ce-cli containerd.io kubeadm kubelet kubectl
                                                                                  


# Setup Docker daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker
