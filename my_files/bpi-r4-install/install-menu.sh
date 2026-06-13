#!/bin/sh
# install-menu.sh - BPI-R4 Pro 8X unified install menu
# Launched automatically from /etc/profile on NAND rescue boot

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

INSTALL_DIR="/root/install-dir"

printf "\n"
printf "${GREEN}=================================================\n"
printf "  BPI-R4 Pro 8X — Rescue System\n"
printf "=================================================${NC}\n"
printf "\n"
printf "  Select installation target:\n"
printf "\n"
printf "   1) NVMe  — standard (WiFi / wired)\n"
printf "   2) eMMC  — standard (WiFi / wired)\n"
printf "   3) NVMe  — UniFi\n"
printf "\n"
printf "   s) Shell — exit to shell\n"
printf "\n"
printf "  Enter choice: "
read CHOICE

printf "\n"

case "$CHOICE" in
    1)
        exec sh "${INSTALL_DIR}/install-nvme.sh"
        ;;
    2)
        exec sh "${INSTALL_DIR}/install-emmc.sh"
        ;;
    3)
        exec sh "${INSTALL_DIR}/install-nvme-unifi.sh"
        ;;
    s|S|"")
        printf "  Dropping to shell. Run install-menu.sh to return.\n\n"
        ;;
    *)
        printf "${RED}  Invalid choice.${NC}\n\n"
        exec sh "$0"
        ;;
esac
