#!/bin/bash

#!/bin/bash

# ------- LARGE Banner display section start

function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

function print_header {
    figlet -c -f slant "$1"
    print_separator
}

# Detection in Yellow color
function print_init {
    local message="$1"
    printf "\e[33m%s\e[0m\n" "$message"  
}

# Intermediate in Blue color
function print_intermediate {
    local message="$1"
    printf "\e[34m%s\e[0m\n" "$message"  
}

# Completion in Green color
function print_success {
    local message="$1"
    printf "\e[1m\e[32m%s\e[0m\n" "$message"  
    print_separator
}

# Failures in Red color
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"  
    print_separator
}

check_figlet_installed() {
    print_separator
    print_header "1 - FIGLET"
    print_separator
    sleep 2
    if command -v figlet &>/dev/null; then
        print_success "Figlet is already installed"  
        return 0
    else
        print_fail "Figlet package is not found in system"
        return 1
    fi
}

check_docker_installed() {
    print_separator
    print_header "2 - DOCKER"
    print_separator
    sleep 2

    docker_installed=true
    docker_compose_installed=true

    if command -v docker &>/dev/null; then
        print_success "Docker is already installed"
    else
        print_fail "Docker Package is missing"
        docker_installed=false
    fi

    if docker compose version &>/dev/null; then
        print_success "Docker Compose is already installed"
    else
        print_fail "Docker Compose Package is missing"
        docker_compose_installed=false
    fi

    if [ "$docker_installed" = true ] && [ "$docker_compose_installed" = true ]; then
        return 0
    else
        return 1
    fi
}

check_trivy_installed() {
    print_separator
    print_header "3 - TRIVY"
    print_separator
    sleep 2
    if command -v trivy &>/dev/null; then
        print_success "Trivy is already installed"  
        return 0
    else
        echo -e "Trivy is not found in system" 
        return 1
    fi
}


install_figlet() {
    if check_figlet_installed; then
        return
    fi
    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    if grep -q 'Ubuntu' /etc/os-release; then
        print_init "Initializing Figlet installation process"
        sudo apt-get update
        sudo apt-get install -y figlet
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    print_separator
}

install_docker() {
    if check_docker_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    if grep -q 'Ubuntu' /etc/os-release; then
        print_init "Initializing Docker installation process"
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
        print_success "Docker installed successfully"
        print_init "starting and enabling Docker service"
        sudo systemctl start docker
        sudo systemctl enable docker
        print_success "Docker service started and enabled"
    fi
    print_separator
}

install_trivy() {
    if check_trivy_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    if grep -q 'Ubuntu' /etc/os-release; then
        print_init "Initializing Docker installation process"
        print_separator
        echo "Installing Trivy for Ubuntu"
        sudo apt-get update
        sudo apt-get install -y wget apt-transport-https gnupg lsb-release
        sudo wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update
        sudo apt-get install -y trivy
        print_success "Trivy installed successfully"
        trivy image --download-db-only
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    print_separator
}

main () {
install_figlet
install_docker
install_trivy
}

main 