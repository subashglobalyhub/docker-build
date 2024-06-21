#!/bin/bash
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
}

# Failures in Red color
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"
}

display_details() {
    print_separator
    print_header "Access Details"
    print_separator

    local_ip=$(hostname -I | cut -d' ' -f1)
    public_ip=$(curl -s ifconfig.me)
    print_fail "FRONTEND"
    echo -n "Access frontend publically: "
    print_intermediate "http://$public_ip:5173"
    echo -n "Access frontend locally: "
    print_intermediate "http://$local_ip:5173"
    echo " "

    print_init "Frontend Directories"
    echo -n "Frontend Conf:    "
    print_success "any-content"
    print_separator

    print_fail "BACKEND"
    print_separator
    echo ""
    echo -n "Access  publically: "
    print_intermediate "http://$public_ip:3000"
    echo -n "Access  locally: "
    print_intermediate "http://$local_ip:3000"
    echo ""
    print_init "Backend Directories"
    echo -n "backend Config:  "
    print_success "any-content"

    echo  " "
    echo  " "
    print_separator
}

main() {
    display_details
}
main