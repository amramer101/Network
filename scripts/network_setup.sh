#!/bin/bash

################################################################################
#                    NETWORK SETUP AUTOMATION SCRIPT
#                  Cisco Packet Tracer Network Configuration
#
# Description: This script automates the configuration of network devices
# Usage: ./network_setup.sh [option]
# Options:
#   setup-router    - Configure routers
#   setup-switch    - Configure switches
#   setup-pc        - Configure PC devices
#   setup-server    - Configure server
#   test-connectivity - Test network connectivity
#   show-config    - Display current configuration
#   all            - Run all configurations
#
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="./logs/network_setup_$(date +%Y%m%d_%H%M%S).log"

################################################################################
# LOGGING FUNCTIONS
################################################################################

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

################################################################################
# ROUTER CONFIGURATION FUNCTIONS
################################################################################

setup_core_router() {
    log "Configuring Core Router (Router0)..."
    
    cat >> "$LOG_FILE" << 'EOF'
─────────────────────────────────────────────────────────────────
CORE ROUTER (Router0) CONFIGURATION
─────────────────────────────────────────────────────────────────

Commands to execute in Cisco Packet Tracer:

enable
configure terminal
hostname CORE-ROUTER-0

interface FastEthernet0/0
  ip address 10.0.0.1 255.255.255.0
  no shutdown

interface FastEthernet0/1
  ip address 10.0.0.2 255.255.255.0
  no shutdown

interface FastEthernet0/2
  ip address 10.0.0.3 255.255.255.0
  no shutdown

ip route 192.168.0.0 255.255.192.0 10.0.1.1
ip route 192.168.64.0 255.255.192.0 10.0.2.1
ip route 192.168.128.0 255.255.128.0 10.0.3.1

exit
end
EOF

    log "Core Router configuration commands saved to log"
}

setup_branch_routers() {
    log "Configuring Branch Routers..."
    
    cat >> "$LOG_FILE" << 'EOF'
─────────────────────────────────────────────────────────────────
BRANCH ROUTER 1 CONFIGURATION
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname BRANCH1-ROUTER-1

interface FastEthernet0/0
  ip address 10.0.1.1 255.255.255.0
  no shutdown

interface FastEthernet0/1
  ip address 192.168.10.1 255.255.255.0
  no shutdown

interface FastEthernet0/2
  ip address 192.168.20.1 255.255.255.0
  no shutdown

interface FastEthernet0/3
  ip address 192.168.30.1 255.255.255.0
  no shutdown

ip route 0.0.0.0 0.0.0.0 10.0.0.1
ip route 192.168.40.0 255.255.252.0 10.0.0.1
ip route 192.168.48.0 255.255.240.0 10.0.0.1

exit
end


─────────────────────────────────────────────────────────────────
BRANCH ROUTER 2 CONFIGURATION
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname BRANCH2-ROUTER-2

interface FastEthernet0/0
  ip address 10.0.2.1 255.255.255.0
  no shutdown

interface FastEthernet0/1
  ip address 192.168.40.1 255.255.255.0
  no shutdown

interface FastEthernet0/2
  ip address 192.168.50.1 255.255.255.0
  no shutdown

ip route 0.0.0.0 0.0.0.0 10.0.0.1
ip route 192.168.10.0 255.255.240.0 10.0.0.1
ip route 192.168.48.0 255.255.240.0 10.0.0.1

exit
end


─────────────────────────────────────────────────────────────────
BRANCH ROUTER 3 CONFIGURATION
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname BRANCH3-ROUTER-3

interface FastEthernet0/0
  ip address 10.0.3.1 255.255.255.0
  no shutdown

interface FastEthernet0/1
  ip address 192.168.60.1 255.255.255.0
  no shutdown

interface FastEthernet0/2
  ip address 192.168.70.1 255.255.255.0
  no shutdown

ip route 0.0.0.0 0.0.0.0 10.0.0.1
ip route 192.168.10.0 255.255.240.0 10.0.0.1
ip route 192.168.40.0 255.255.252.0 10.0.0.1

exit
end
EOF

    log "Branch Router configurations saved to log"
}

################################################################################
# SWITCH CONFIGURATION FUNCTIONS
################################################################################

setup_switches() {
    log "Configuring Switches with VLANs..."
    
    cat >> "$LOG_FILE" << 'EOF'
─────────────────────────────────────────────────────────────────
SWITCH 1 CONFIGURATION (HR Department)
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname SWITCH-1

vlan 10
  name HR_Department

interface FastEthernet0/1
  switchport mode access
  switchport access vlan 10
  no shutdown

interface FastEthernet0/2
  switchport mode access
  switchport access vlan 10
  no shutdown

interface FastEthernet0/3
  switchport mode access
  switchport access vlan 10
  no shutdown

interface GigabitEthernet0/1
  switchport mode access
  switchport access vlan 10
  no shutdown

ip default-gateway 192.168.10.1

exit
end


─────────────────────────────────────────────────────────────────
SWITCH 2 CONFIGURATION (IT Department)
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname SWITCH-2

vlan 20
  name IT_Department

interface FastEthernet0/1
  switchport mode access
  switchport access vlan 20
  no shutdown

interface FastEthernet0/2
  switchport mode access
  switchport access vlan 20
  no shutdown

interface FastEthernet0/3
  switchport mode access
  switchport access vlan 20
  no shutdown

interface GigabitEthernet0/1
  switchport mode access
  switchport access vlan 20
  no shutdown

ip default-gateway 192.168.20.1

exit
end


─────────────────────────────────────────────────────────────────
SWITCH 3 CONFIGURATION (Sales Department)
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname SWITCH-3

vlan 30
  name Sales_Department

interface FastEthernet0/1
  switchport mode access
  switchport access vlan 30
  no shutdown

interface FastEthernet0/2
  switchport mode access
  switchport access vlan 30
  no shutdown

interface FastEthernet0/3
  switchport mode access
  switchport access vlan 30
  no shutdown

interface GigabitEthernet0/1
  switchport mode access
  switchport access vlan 30
  no shutdown

ip default-gateway 192.168.30.1

exit
end


─────────────────────────────────────────────────────────────────
SWITCH 4 CONFIGURATION (Operations 1)
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname SWITCH-4

vlan 40
  name Operations_1

interface FastEthernet0/1
  switchport mode access
  switchport access vlan 40
  no shutdown

interface FastEthernet0/2
  switchport mode access
  switchport access vlan 40
  no shutdown

interface FastEthernet0/3
  switchport mode access
  switchport access vlan 40
  no shutdown

interface GigabitEthernet0/1
  switchport mode access
  switchport access vlan 40
  no shutdown

ip default-gateway 192.168.40.1

exit
end


─────────────────────────────────────────────────────────────────
SWITCH 5 CONFIGURATION (Operations 2)
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname SWITCH-5

vlan 50
  name Operations_2

interface FastEthernet0/1
  switchport mode access
  switchport access vlan 50
  no shutdown

interface FastEthernet0/2
  switchport mode access
  switchport access vlan 50
  no shutdown

interface GigabitEthernet0/1
  switchport mode access
  switchport access vlan 50
  no shutdown

ip default-gateway 192.168.50.1

exit
end


─────────────────────────────────────────────────────────────────
SWITCH 6 CONFIGURATION (Support & Management & Server)
─────────────────────────────────────────────────────────────────

enable
configure terminal
hostname SWITCH-6

vlan 60
  name Support_Team

vlan 70
  name Management

vlan 100
  name Server_VLAN

interface FastEthernet0/1
  switchport mode access
  switchport access vlan 60
  no shutdown

interface FastEthernet0/2
  switchport mode access
  switchport access vlan 70
  no shutdown

interface GigabitEthernet0/1
  switchport mode access
  switchport access vlan 100
  no shutdown

interface GigabitEthernet0/2
  switchport mode access
  switchport access vlan 60
  no shutdown

ip default-gateway 192.168.60.1

exit
end
EOF

    log "Switch configurations saved to log"
}

################################################################################
# CONNECTIVITY TESTING FUNCTIONS
################################################################################

test_connectivity() {
    log "Network Connectivity Test..."
    
    cat >> "$LOG_FILE" << 'EOF'
─────────────────────────────────────────────────────────────────
CONNECTIVITY TEST COMMANDS (Run from any PC)
─────────────────────────────────────────────────────────────────

1. Test Same VLAN Connectivity (HR Department):
   From PC1 (192.168.10.1):
   $ ping 192.168.10.2
   Expected: 4 replies received (0% packet loss)
   
   From PC1 to PC3:
   $ ping 192.168.10.3
   Expected: 4 replies received (0% packet loss)

2. Test Cross-VLAN Connectivity (through Router):
   From PC1 (VLAN10) to PC4 (VLAN20):
   $ ping 192.168.20.1
   Expected: 4 replies received (0% packet loss)

3. Test Server Connectivity (from any VLAN):
   From any PC:
   $ ping 192.168.100.10
   Expected: 4 replies received (0% packet loss)

4. Test Router Interface:
   From any PC in Branch1:
   $ ping 192.168.10.1 (Local Router)
   Expected: 4 replies received (0% packet loss)

5. Test Route to Other Branch:
   From PC1 (Branch1) to PC10 (Branch2):
   $ ping 192.168.40.1
   Expected: 4 replies received (0% packet loss)

6. Trace Route (shows path):
   From PC1 to Server:
   $ tracert 192.168.100.10
   Expected: Multiple hops through routers

7. Verify VLAN Isolation (negative test):
   From PC1 (VLAN10) to PC4 (VLAN20):
   Direct communication should FAIL
   Must go through router
   
   From PC1:
   $ ping 192.168.20.2
   Expected: First fails (local), then succeeds (via router)


─────────────────────────────────────────────────────────────────
EXPECTED CONNECTIVITY MATRIX
─────────────────────────────────────────────────────────────────

Same VLAN:
  PC1 ↔ PC2 ✓ (Direct)
  PC4 ↔ PC5 ✓ (Direct)
  PC10 ↔ PC11 ✓ (Direct)

Different VLAN (Same Branch):
  PC1 ↔ PC4 ✓ (Via Router1)
  PC1 ↔ PC7 ✓ (Via Router1)

Different VLAN (Different Branch):
  PC1 ↔ PC10 ✓ (Via Router0 & Router2)
  PC4 ↔ PC15 ✓ (Via Router0 & Router3)

Server Access (Any VLAN):
  PC1 ↔ Server ✓ (Via Router0 & Router3)
  PC15 ↔ Server ✓ (Direct/Via Router3)

Internet (Default Route):
  Any PC → 10.0.0.1 ✓ (Via respective Router & Core)
EOF

    log "Connectivity test procedures saved to log"
}

################################################################################
# CONFIGURATION SUMMARY
################################################################################

show_configuration_summary() {
    log "Network Configuration Summary"
    
    cat >> "$LOG_FILE" << 'EOF'
═════════════════════════════════════════════════════════════════
                 NETWORK CONFIGURATION SUMMARY
═════════════════════════════════════════════════════════════════

ROUTERS (4 Total):
├─ Router0 (Core)
│  ├─ Fa0/0: 10.0.0.1/24
│  ├─ Fa0/1: 10.0.0.2/24
│  └─ Fa0/2: 10.0.0.3/24
├─ Router1 (Branch1)
│  ├─ Fa0/0: 10.0.1.1/24
│  ├─ Fa0/1: 192.168.10.1/24 (VLAN10)
│  ├─ Fa0/2: 192.168.20.1/24 (VLAN20)
│  └─ Fa0/3: 192.168.30.1/24 (VLAN30)
├─ Router2 (Branch2)
│  ├─ Fa0/0: 10.0.2.1/24
│  ├─ Fa0/1: 192.168.40.1/24 (VLAN40)
│  └─ Fa0/2: 192.168.50.1/24 (VLAN50)
└─ Router3 (Branch3)
   ├─ Fa0/0: 10.0.3.1/24
   ├─ Fa0/1: 192.168.60.1/24 (VLAN60)
   └─ Fa0/2: 192.168.70.1/24 (VLAN70)

SWITCHES (6 Total):
├─ Switch1: VLAN10 (HR) - 3 PCs + Router
├─ Switch2: VLAN20 (IT) - 3 PCs + Router
├─ Switch3: VLAN30 (Sales) - 3 PCs + Router
├─ Switch4: VLAN40 (Ops1) - 3 PCs + Router
├─ Switch5: VLAN50 (Ops2) - 2 PCs + Router
└─ Switch6: VLAN60/70/100 - 2 PCs + Router + Server

VLANS (8 Total):
├─ VLAN10: HR Department (192.168.10.0/24)
├─ VLAN20: IT Department (192.168.20.0/24)
├─ VLAN30: Sales Department (192.168.30.0/24)
├─ VLAN40: Operations 1 (192.168.40.0/24)
├─ VLAN50: Operations 2 (192.168.50.0/24)
├─ VLAN60: Support Team (192.168.60.0/24)
├─ VLAN70: Management (192.168.70.0/24)
└─ VLAN100: Server VLAN (192.168.100.0/24)

PCs (16 Total):
├─ PC1-3: VLAN10 (HR)
├─ PC4-6: VLAN20 (IT)
├─ PC7-9: VLAN30 (Sales)
├─ PC10-12: VLAN40 (Ops1)
├─ PC13-14: VLAN50 (Ops2)
├─ PC15: VLAN60 (Support)
└─ PC16: VLAN70 (Management)

SERVER (1 Total):
└─ Server1: 192.168.100.10/24 (VLAN100)

TOTAL DEVICES: 24

═════════════════════════════════════════════════════════════════
EOF

    cat "$LOG_FILE"
}

################################################################################
# HELP FUNCTION
################################################################################

show_help() {
    cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════╗
║           NETWORK SETUP AUTOMATION SCRIPT - HELP                       ║
╚════════════════════════════════════════════════════════════════════════╝

USAGE: ./network_setup.sh [OPTION]

OPTIONS:
────────────────────────────────────────────────────────────────────────

  setup-router        Configure all routers (Core + Branches)
  setup-switch        Configure all switches with VLANs
  setup-pc            Display PC network configurations
  setup-server        Display server configuration
  test-connectivity   Show connectivity test procedures
  show-config         Display full configuration summary
  all                 Run all setup steps
  help                Show this help message

EXAMPLES:
────────────────────────────────────────────────────────────────────────

  ./network_setup.sh all
  ./network_setup.sh setup-router
  ./network_setup.sh test-connectivity
  ./network_setup.sh show-config

OUTPUT:
────────────────────────────────────────────────────────────────────────

All logs are saved to: ./logs/network_setup_YYYYMMDD_HHMMSS.log

════════════════════════════════════════════════════════════════════════

EOF
}

################################################################################
# MAIN FUNCTION
################################################################################

main() {
    # Create logs directory if it doesn't exist
    mkdir -p logs
    
    log "════════════════════════════════════════════════════════════════"
    log "     CISCO PACKET TRACER NETWORK SETUP AUTOMATION"
    log "════════════════════════════════════════════════════════════════"
    
    case "${1:-all}" in
        setup-router)
            setup_core_router
            setup_branch_routers
            log "✓ Router configurations complete"
            ;;
        setup-switch)
            setup_switches
            log "✓ Switch configurations complete"
            ;;
        setup-pc)
            info "PC configurations are in: ./configs/PC_CONFIG.txt"
            log "Display PC Config (from file)"
            ;;
        setup-server)
            info "Server configuration is in: ./configs/SERVER_CONFIG.txt"
            log "Display Server Config (from file)"
            ;;
        test-connectivity)
            test_connectivity
            log "✓ Connectivity test procedures saved"
            ;;
        show-config|show-summary)
            show_configuration_summary
            ;;
        all)
            setup_core_router
            setup_branch_routers
            setup_switches
            test_connectivity
            show_configuration_summary
            log "✓ All configurations complete!"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    
    log "════════════════════════════════════════════════════════════════"
    log "Log saved to: $LOG_FILE"
    log "════════════════════════════════════════════════════════════════"
}

# Run main function with all arguments
main "$@"
