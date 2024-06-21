#!/bin/bash

function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

function print_header {
    figlet -c -f slant "$1"
    print_separator
}

# Function to check if Figlet is installed
check_figlet_installed() {
    print_separator
    print_header "1 - FIGLET"
    print_separator
    sleep 2
    if command -v figlet &>/dev/null; then
        echo -e "\e[1m\e[32mFiglet is already installed\e[0m"  # Print in bold and green color
        return 0
    else
        return 1
    fi
}

# Function to check if Docker is installed
check_docker_installed() {
    print_separator
    print_header "2 - DOCKER"
    print_separator
    sleep 2
    if command -v docker &>/dev/null; then
        echo -e "\e[1m\e[32mDocker is already installed\e[0m"  # Print in bold and green color
        return 0
    else
        echo -e "\e[1m\e[31mDocker is not installed\e[0m"  # Print in bold and red color
        return 1
    fi
}


# Function to check if Trivy is installed
check_trivy_installed() {
    print_separator
    print_header "4 - TRIVY"
    print_separator
    sleep 2
    if command -v trivy &>/dev/null; then
        echo -e "\e[1m\e[32mTrivy is already installed\e[0m"  # Print in bold and green color
        return 0
    else
        echo -e "\e[1m\e[31mTrivy is not installed\e[0m"  # Print in bold and red color
        return 1
    fi
}

# Function to install Figlet
install_figlet() {
    if check_figlet_installed; then
        return
    fi

    if grep -q 'Amazon Linux 2' /etc/os-release || grep -q 'Amazon Linux 3' /etc/os-release; then
        # Amazon Linux 2 or Amazon Linux 3
        print_separator
        echo "Detected Amazon Linux"
        sudo amazon-linux-extras install epel -y
        sudo yum -y install figlet
    elif grep -q 'Ubuntu' /etc/os-release; then
        # Ubuntu
        print_separator
        echo "Detected Ubuntu"
        sudo apt-get update
        sudo apt-get install -y figlet
    elif grep -qEi 'redhat|centos' /etc/os-release; then
        # Red Hat or CentOS
        print_separator
        echo "Detected Red Hat or CentOS"
        sudo yum -y install figlet
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
}

# Function to install Docker
install_docker() {
    if check_docker_installed; then
        return
    fi

    if grep -q 'Amazon Linux 2' /etc/os-release; then
        # Amazon Linux 2
        echo "Detected Amazon Linux 2"
        sudo yum update -y
        yes | sudo amazon-linux-extras install docker
        echo -e "\e[1m\e[32mDocker installed successfully\e[0m"  # Print in bold and green color
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker service started and enabled"
    elif grep -q 'Amazon Linux 3' /etc/os-release; then
        # Amazon Linux 3
        echo "Detected Amazon Linux 3"
        sudo yum update -y
        yes | sudo yum install -y docker
        echo -e "\e[1m\e[32mDocker installed successfully\e[0m"  # Print in bold and green color
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker service started and enabled"

    elif grep -q 'Ubuntu' /etc/os-release; then
        # Ubuntu
        echo "Detected Ubuntu"
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        yes | sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        echo -e "\e[1m\e[32mDocker installed successfully\e[0m"  # Print in bold and green color
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker service started and enabled"
}

install_trivy() {
    if check_trivy_installed; then
        return
    fi

    if grep -q 'Ubuntu' /etc/os-release; then
        # Ubuntu
        echo "Detected Ubuntu"
        print_separator
        echo "Installing Trivy for Ubuntu"
        sudo apt-get update
        sudo apt-get install -y wget apt-transport-https gnupg lsb-release
        sudo wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update
        sudo apt-get install -y trivy
        echo -e "\e[1m\e[32mTrivy installed successfully\e[0m"  # Print in bold and green color
        trivy image --download-db-only
}


# Function to print separator
print_separator() {
    echo "----------------------------------------"
}

main ()
{
install_figlet
install_docker
install_trivy
}

main 