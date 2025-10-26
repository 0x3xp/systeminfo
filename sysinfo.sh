#!/bin/bash
# ==============================================
#   Debian System Information Tool
#   Author: Piyusha Akash
#   Version: 1.0.0
# ==============================================

# -------------[ Color & Style Variables ]-------------
BOLD=$(tput bold) #color
RESET=$(tput sgr0) #color
BLACK=$(tput setaf 0) #color
RED=$(tput setaf 1) #color
GREEN=$(tput setaf 2) #color
YELLOW=$(tput setaf 3) #color
BLUE=$(tput setaf 4) #color
MAGENTA=$(tput setaf 5) #color
CYAN=$(tput setaf 6) #color
WHITE=$(tput setaf 7) #color

# -------------[ Helper Functions ]-------------
line() { echo -e "${CYAN}──────────────────────────────────────────────────────────────${RESET}"; }


header() {
  clear
  cat << "EOF"
               	            .--.
              	           |o_o |
              	           |:_/ |
              	          //   \ \
             	         (|     | )
            	        /'\_   _/`\
         	     v1 \___)=(___/  0x3xp
        	    =======================
      	            Welcome user! I am Tux!
        	    =======================

EOF

  echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════════╗"
  echo -e "║                   ${WHITE}System Info - Debian Dashboard${CYAN}             ║"
  echo -e "╚══════════════════════════════════════════════════════════════╝${RESET}\n"
}

progress_bar() {
  local value=$1
  local bar_len=40
  local filled=$((value * bar_len / 100))
  local empty=$((bar_len - filled))
  printf "[${GREEN}%${filled}s${RESET}${WHITE}%${empty}s${RESET}] %d%%" | tr ' ' '#' | tr '%' ' '
  printf "\r"
}

# -------------[ Info Sections ]-------------
system_info() {
  echo -e "${BOLD}${BLUE}📦 System Information${RESET}"
  line
  echo -e "${YELLOW}Hostname:${RESET} $(hostname)"
  echo -e "${YELLOW}OS:${RESET} $(lsb_release -ds 2>/dev/null || echo "Debian")"
  echo -e "${YELLOW}Kernel:${RESET} $(uname -r)"
  echo -e "${YELLOW}Uptime:${RESET} $(uptime -p)"
  echo -e "${YELLOW}Architecture:${RESET} $(uname -m)"
  echo
}

user_info() {
  echo -e "${BOLD}${MAGENTA}👤 User Information${RESET}"
  line
  echo -e "${YELLOW}User:${RESET} $USER"
  echo -e "${YELLOW}Home:${RESET} $HOME"
  echo -e "${YELLOW}Shell:${RESET} $SHELL"
  echo -e "${YELLOW}Logged In Since:${RESET} $(who -b | awk '{print $3, $4}')"
  echo
}

hardware_info() {
  echo -e "${BOLD}${GREEN}💻 Hardware Overview${RESET}"
  line
  echo -e "${YELLOW}CPU:${RESET} $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
  echo -e "${YELLOW}Cores:${RESET} $(nproc)"
  gpu=$(lspci | grep -i 'vga' | cut -d: -f3 | xargs)
  [[ -n "$gpu" ]] && echo -e "${YELLOW}GPU:${RESET} $gpu"
  echo
}

memory_info() {
  echo -e "${BOLD}${CYAN}🧠 Memory Usage${RESET}"
  line
  total=$(free -m | awk '/Mem/{print $2}')
  used=$(free -m | awk '/Mem/{print $3}')
  percent=$((used * 100 / total))
  echo -n "RAM: "
  progress_bar $percent
  echo
  echo -e "${YELLOW}Total:${RESET} ${total}MB   ${YELLOW}Used:${RESET} ${used}MB"
  echo
}

disk_info() {
  echo -e "${BOLD}${WHITE}💾 Disk Usage${RESET}"
  line
  df -h --output=source,size,used,avail,pcent | column -t | grep -E '^/dev/' | head -n 5
  echo
}

network_info() {
  echo -e "${BOLD}${YELLOW}🌐 Network Information${RESET}"
  line
  echo -e "${YELLOW}IP Address:${RESET} $(hostname -I | awk '{print $1}')"
  echo -e "${YELLOW}Gateway:${RESET} $(ip route | grep default | awk '{print $3}')"
  echo -e "${YELLOW}DNS:${RESET} $(grep nameserver /etc/resolv.conf | awk '{print $2}' | head -1)"
  wifi=$(iwgetid -r 2>/dev/null)
  [[ -n "$wifi" ]] && echo -e "${YELLOW}Wi-Fi SSID:${RESET} $wifi"
  echo
}

process_info() {
  echo -e "${BOLD}${RED}⚙️ Top Processes (CPU)%${RESET}"
  line
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6 | awk '{printf "%-8s %-20s %-8s %-8s\n", $1, $2, $3, $4}'
  echo
}

updates_info() {
  echo -e "${BOLD}${MAGENTA}🔒 Security & Updates${RESET}"
  line
  updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
  echo -e "${YELLOW}Pending Updates:${RESET} ${updates}"
  echo -e "${YELLOW}Firewall:${RESET} $(sudo ufw status | head -n 1 2>/dev/null || echo "Unavailable")"
  echo
}

footer() {
  line
  echo -e "${BOLD}${BLUE}Code Developed by Piyusha Akash © 2025${RESET}"
  echo -e "${BOLD}${BLUE}UI Developed by using ChatGPT${RESET}"

}

# -------------[ Main Execution ]-------------
header
system_info
user_info
hardware_info
memory_info
disk_info
network_info
process_info
updates_info
footer
