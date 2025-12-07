# Complete VLAN Configuration Guide

## Virtual Local Area Network (VLAN) Implementation & Management

---

## Table of Contents
1. VLAN Concepts
2. VLAN Configuration
3. VLAN Routing (Inter-VLAN Communication)
4. VLAN Security
5. VLAN Troubleshooting
6. VLAN Management

---

## 1. VLAN CONCEPTS & THEORY

### 1.1 What is a VLAN?

A Virtual Local Area Network (VLAN) is a logical grouping of network devices that:
- Share the same broadcast domain
- Operate as if connected to same switch
- Can be separated physically
- Provide logical network segmentation

```
Physical Network (One Building):
┌─────────────────────────────────────┐
│      SWITCH (24 ports)              │
│                                     │
│  Ports 1-3:  HR Staff (VLAN 10)    │
│  Ports 4-6:  IT Staff (VLAN 20)    │
│  Ports 7-9:  Sales (VLAN 30)       │
│  Ports 10-12: Ops (VLAN 40)        │
│  Ports 13-15: Server (VLAN 100)    │
│  Ports 16-24: Free/Reserved        │
└─────────────────────────────────────┘

Logical Network (Separated by VLAN):
VLAN 10: HR Department (isolated)
VLAN 20: IT Department (isolated)
VLAN 30: Sales Department (isolated)
VLAN 40: Operations (isolated)
VLAN 100: Servers (isolated)
```

### 1.2 VLAN Benefits

```
✅ Segmentation
   - Isolate departments
   - Reduce broadcast traffic
   - Contain security breaches

✅ Cost Reduction
   - Share infrastructure
   - No need for separate physical switches
   - Better resource utilization

✅ Security
   - Control inter-VLAN traffic with router
   - Implement access control policies
   - Restrict service access

✅ Flexibility
   - Easy to add/remove devices
   - Scalable network design
   - Move devices without rewiring

✅ Performance
   - Smaller broadcast domains
   - Less congestion
   - Prioritize critical traffic
```

### 1.3 VLAN Types

#### Static VLAN (Port-Based)
```
Configuration: Assign VLAN to physical port
Persistence: Stays with port regardless of device
Use Case: Most common, stable environments
Example:
  switch> interface Fa0/1
  switch> switchport access vlan 10
  (VLAN 10 assigned to port, regardless of device)
```

#### Dynamic VLAN (MAC-Based)
```
Configuration: Assign VLAN based on MAC address
Persistence: Follows device (device jumps to new port)
Use Case: Mobile devices, hotdesking
Requirement: VLAN Membership Policy Server (VMPS)
Example:
  VLAN database: 
    MAC 00:11:22:33:44:55 → VLAN 20
  Device moves to any port → Automatically VLAN 20
```

#### Voice VLAN
```
Purpose: Separate voice traffic from data
Priority: Higher priority than data
Use Case: IP phones, VoIP systems
Configuration: Access VLAN (data) + Voice VLAN (voice)
```

#### Management VLAN
```
Purpose: Manage switches remotely
Access: Telnet, SSH, SNMP
Configuration: VLAN with switch IP address
Example: VLAN 99 (Management) IP: 192.168.99.1
```

### 1.4 VLAN Identification

#### VLAN ID Range
```
1      : Reserved (default VLAN, can't delete)
2-1001 : Normal VLANs (stored in VLAN.dat file)
1002-1005: Reserved (Token Ring, FDDI)
1006-4094: Extended VLANs (stored in running-config)
4095   : Reserved
```

#### VLAN Tagging Methods

**802.1Q Tagging (Standard)**
```
Frame Format:
┌──────┬────┬─────┬──────┬──────────┬─────┐
│ Dest │Src │802.1Q│Type │ Payload │ CRC │
│ MAC  │MAC │ Tag  │     │         │     │
└──────┴────┴─────┴──────┴──────────┴─────┘
        ↓
    VLAN ID + Priority

Example: VLAN 10, Priority 3
```

**ISL Tagging (Cisco Proprietary)**
```
Encapsulation: Wraps entire frame
Support: Cisco devices only
Status: Legacy (not used in this project)
```

---

## 2. VLAN CONFIGURATION

### 2.1 Basic VLAN Setup

#### Step 1: Create VLAN on Switch

```
Switch# configure terminal
Switch(config)# vlan 10
Switch(config-vlan)# name HR_Department
Switch(config-vlan)# exit

Switch(config)# vlan 20
Switch(config-vlan)# name IT_Department
Switch(config-vlan)# exit

Switch(config)# vlan 30
Switch(config-vlan)# name Sales_Department
Switch(config-vlan)# exit

! Save configuration
Switch# copy running-config startup-config
```

#### Step 2: Verify VLAN Creation

```
Switch# show vlan brief

VLAN Name                             Status    Ports
---- -------------------------------- --------- ------
1    default                          active    Fa0/1-24
10   HR_Department                    active
20   IT_Department                    active
30   Sales_Department                 active
1002 fddi-default                     act/unsup
1003 trmk-default                     act/unsup
1004 fddinet-default                  act/unsup
1005 trneti-default                   act/unsup

(Note: VLANs created but no ports assigned yet)
```

#### Step 3: Assign Ports to VLANs

```
Switch# configure terminal

! Assign ports 1-3 to VLAN 10 (HR)
Switch(config)# interface range Fa0/1-3
Switch(config-if-range)# switchport mode access
Switch(config-if-range)# switchport access vlan 10
Switch(config-if-range)# no shutdown
Switch(config-if-range)# exit

! Assign ports 4-6 to VLAN 20 (IT)
Switch(config)# interface range Fa0/4-6
Switch(config-if-range)# switchport mode access
Switch(config-if-range)# switchport access vlan 20
Switch(config-if-range)# no shutdown
Switch(config-if-range)# exit

! Assign ports 7-9 to VLAN 30 (Sales)
Switch(config)# interface range Fa0/7-9
Switch(config-if-range)# switchport mode access
Switch(config-if-range)# switchport access vlan 30
Switch(config-if-range)# no shutdown
Switch(config-if-range)# exit

Switch# copy running-config startup-config
```

#### Step 4: Verify Port Assignments

```
Switch# show vlan id 10

VLAN Name                             Status    Ports
---- -------------------------------- --------- ------
10   HR_Department                    active    Fa0/1, Fa0/2, Fa0/3

Switch# show interface Fa0/1 switchport

Name: Fa0/1
Encapsulation negotiation: On
Operating Mode: static access
Access Mode VLAN: 10 (HR_Department)
Trunking Mode Native VLAN: 1
```

### 2.2 Trunk Configuration

#### Why Trunk?
```
Trunk = Multiple VLANs on single link

Use Case: Switch-to-Switch or Switch-to-Router
┌──────────────┐                    ┌──────────────┐
│   Switch1    │──────────────────__|   Switch2    │
│              │  1 Trunk Link      │              │
│ VLAN 10,20   │  (carries all)     │ VLAN 10,20   │
└──────────────┘                    └──────────────┘

Without Trunk (per-VLAN links - wasteful):
┌──────────────┐  Link1  ┌──────────────┐
│   Switch1    │─────────|   Switch2    │
│ VLAN 10      │ (carries only VLAN 10) │ VLAN 10
└──────────────┘                    └──────────────┘
       ↓ Link2
│   Switch2    │ (carries only VLAN 20) │ VLAN 20
└──────────────┘
```

#### Trunk Configuration

```
Switch# configure terminal

! Configure port 24 as trunk
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk native vlan 1
Switch(config-if)# switchport trunk allowed vlan 10,20,30,40,50,60,70,100
Switch(config-if)# no shutdown
Switch(config-if)# exit

Switch# copy running-config startup-config
```

#### Verify Trunk

```
Switch# show interface GigabitEthernet0/1 trunk

Port        Mode         Encapsulation  Status        Native vlan
Gi0/1       on           802.1q         trunking      1

Port        Vlans allowed on trunk
Gi0/1       10,20,30,40,50,60,70,100

Port        Vlans allowed and active in management domain
Gi0/1       10,20,30,40,50,60,70,100

Port        Vlans in spanning tree forwarding state and not pruned
Gi0/1       10,20,30,40,50,60,70,100
```

---

## 3. INTER-VLAN ROUTING

### 3.1 The Problem: VLANs Can't Talk to Each Other

```
Without Inter-VLAN Routing:
VLAN 10 (HR):        192.168.10.0/24
  PC1: 192.168.10.1

VLAN 20 (IT):        192.168.20.0/24
  PC4: 192.168.20.1

PC1 pings PC4: NO RESPONSE
(Different subnets, can't communicate)

Solution: Use Router to Route Between VLANs
```

### 3.2 Router on a Stick (Single Connection)

#### Configuration

```
┌──────────────┐                    ┌────────────────┐
│   Switch1    │ ─ Trunk ─ ───────── │   Router1      │
│              │  (802.1Q tagged)    │                │
│ VLAN 10,20   │                     │ Fa0/1.10 (HR)  │
└──────────────┘                     │ Fa0/1.20 (IT)  │
                                     └────────────────┘

Router processes tagged frames:
  Tag=10 → Route using 192.168.10.1
  Tag=20 → Route using 192.168.20.1
```

#### Router Configuration

```
Router# configure terminal

! Configure physical interface
Router(config)# interface FastEthernet0/1
Router(config-if)# no shutdown
Router(config-if)# exit

! Configure subinterface for VLAN 10 (HR)
Router(config)# interface FastEthernet0/1.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0
Router(config-subif)# exit

! Configure subinterface for VLAN 20 (IT)
Router(config)# interface FastEthernet0/1.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0
Router(config-subif)# exit

! Configure subinterface for VLAN 30 (Sales)
Router(config)# interface FastEthernet0/1.30
Router(config-subif)# encapsulation dot1Q 30
Router(config-subif)# ip address 192.168.30.1 255.255.255.0
Router(config-subif)# exit

Router(config)# exit
Router# copy running-config startup-config
```

#### Verify Configuration

```
Router# show ip interface brief

Interface              IP-Address      OK? Method Status Protocol
FastEthernet0/1        unassigned      YES unset  up     up
FastEthernet0/1.10     192.168.10.1    YES manual up     up
FastEthernet0/1.20     192.168.20.1    YES manual up     up
FastEthernet0/1.30     192.168.30.1    YES manual up     up

Router# show vlans

802.1Q Tagged VLAN Routing Information
Vlan  Ip Address      Mask            Metric  Txload  Rxload
10    192.168.10.1    255.255.255.0   -       1       1
20    192.168.20.1    255.255.255.0   -       1       1
30    192.168.30.1    255.255.255.0   -       1       1
```

### 3.3 Multi-Interface Router (More Common)

```
This Network Design:
┌──────────────┐
│   Switch1    │
├──────────────┤
│ Fa0/1-3: VLAN 10 │
│ Fa0/4-6: VLAN 20 │
│ Fa0/7-9: VLAN 30 │
│ Gi0/1: Trunk     │
└──────────────┘
       ↓
   Trunk to Router1
       ↓
  ┌─────────────┐
  │  Router1    │
  ├─────────────┤
  │ Fa0/0: Backbone      │ (to Router0)
  │ Fa0/1: VLAN 10 gate  │ 192.168.10.1
  │ Fa0/2: VLAN 20 gate  │ 192.168.20.1
  │ Fa0/3: VLAN 30 gate  │ 192.168.30.1
  │ Gi0/1: Trunk to Sw1  │
  └─────────────┘
```

#### This Network's Configuration

```
Router1# show ip interface brief

Interface              IP-Address      Status
FastEthernet0/0        10.0.1.1        up        (Backbone)
FastEthernet0/1        192.168.10.1    up        (HR VLAN)
FastEthernet0/2        192.168.20.1    up        (IT VLAN)
FastEthernet0/3        192.168.30.1    up        (Sales VLAN)
GigabitEthernet0/1     (Not used)      down
```

---

## 4. VLAN SECURITY

### 4.1 VLAN Isolation

#### What Gets Isolated?
```
✅ Traffic between different VLANs (isolated by router)
✅ Broadcast traffic (contained within VLAN)
✅ ARP requests (don't cross VLAN boundaries)

❌ Traffic within same VLAN (not isolated - all ports see all traffic)
❌ Management traffic (can be accessed from any VLAN with permission)
```

#### Example: VLAN 10 Isolation
```
VLAN 10 (HR) contains: PC1, PC2, PC3, Printer1
  PC1 ↔ PC2: YES (same VLAN, direct communication)
  PC1 ↔ Printer1: YES (same VLAN, can print directly)
  
VLAN 10 ↔ VLAN 20: Requires Router (can be blocked)
  PC1 → (router) → PC4: Only if router permits
```

### 4.2 Access Control Lists (ACL)

#### Control Inter-VLAN Traffic

```
Scenario: Allow HR to access Server, but not IT systems

Router# configure terminal

! Create ACL to allow HR → Server only
Router(config)# access-list 100 permit ip 192.168.10.0 0.0.0.255 192.168.100.0 0.0.0.255
Router(config)# access-list 100 deny ip 192.168.10.0 0.0.0.255 192.168.20.0 0.0.0.255
Router(config)# access-list 100 deny ip 192.168.10.0 0.0.0.255 192.168.30.0 0.0.0.255
Router(config)# access-list 100 permit ip any any

! Apply to router interface
Router(config)# interface FastEthernet0/1
Router(config-if)# ip access-group 100 in
Router(config-if)# exit

Router(config)# exit
Router# show access-lists
```

### 4.3 VLAN Hopping Prevention

#### Attack: VLAN Hopping
```
Attacker: On VLAN 10
Goal: Access VLAN 20 without going through router

Method 1: Double Tagging
  Frame format: [VLAN 20][VLAN 10][Payload]
  Switch1 strips outer tag (VLAN 10) → sees VLAN 20 → forwards

Prevention: Always use explicit native VLAN
```

#### Prevention Configuration

```
Switch# configure terminal

! Set native VLAN explicitly (not VLAN 1)
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# switchport trunk native vlan 99
Switch(config-if)# switchport trunk allowed vlan 10,20,30,40,50,60,70,100
Switch(config-if)# exit

! Remove VLAN 1 from trunk allowed
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# switchport trunk allowed vlan remove 1
Switch(config-if)# exit

Switch# copy running-config startup-config
```

### 4.4 Spanning Tree for VLAN Loops

#### Why Needed?
```
Multiple trunk links can create loops:
┌──────────┐           ┌──────────┐
│Switch1   │─Link1─────│Switch2   │
│          │─Link2─────│          │
└──────────┘           └──────────┘

Problem: Frames circulate infinitely
Solution: Spanning Tree Protocol (STP)
```

#### Spanning Tree Configuration

```
Switch# configure terminal

! Enable spanning tree (usually default)
Switch(config)# spanning-tree mode rapid-pvst

! Verify spanning tree
Switch# show spanning-tree

VLAN0010
  Spanning tree enabled protocol rstp
  Root ID    Priority 32778
             Address 0001.4425.a701
             This bridge is the root
  Bridge ID  Priority 32778
             Address 0001.4425.a701
  Interface        Role Sts Cost
  Fa0/1            Desg FWD 19
  Fa0/2            Desg FWD 19
```

---

## 5. VLAN TROUBLESHOOTING

### 5.1 Devices on Same VLAN Can't Communicate

#### Quick Diagnostics

```
Check 1: Devices are in same VLAN
  show vlan
  show interface Fa0/1 switchport | include "Access Mode VLAN"
  (Both should show same VLAN ID)

Check 2: VLAN is active
  show vlan | include "VLAN Name Status"
  (Status should be "active")

Check 3: Port is enabled
  show interface status
  (Status should not be "disabled")

Check 4: Physical connection
  (Green light on port indicator)
```

#### Example Troubleshooting

```
PC1 (192.168.10.1) can't ping PC2 (192.168.10.2)

Step 1: Check PC1 IP
  PC1 Config:
    IP: 192.168.10.1 ✓
    Mask: 255.255.255.0 ✓
    Gateway: 192.168.10.1 ✓

Step 2: Check PC2 IP
  PC2 Config:
    IP: 192.168.10.2 ✓
    Mask: 255.255.255.0 ✓
    Gateway: 192.168.10.1 ✓

Step 3: Check Switch Port for PC1
  show interface Fa0/1 switchport
    Access Mode VLAN: 10 ✓

Step 4: Check Switch Port for PC2
  show interface Fa0/2 switchport
    Access Mode VLAN: 10 ✓

Step 5: Check VLAN exists
  show vlan brief | include "VLAN10"
    VLAN 10: HR_Department active ✓

Step 6: Enable port if disabled
  configure terminal
  interface Fa0/1
  no shutdown

Result: Ping now works ✓
```

### 5.2 Different VLAN Communication Fails

#### Diagnostics

```
Check 1: Router has interface for each VLAN
  show ip interface brief
  Should show:
    Fa0/1.10: 192.168.10.1
    Fa0/1.20: 192.168.20.1
    etc.

Check 2: Router interfaces are up
  show ip interface brief | include "up"

Check 3: Router has correct gateways
  show ip route
  Should include default route to next router

Check 4: Switch has trunk to router
  show interface Gi0/1 trunk
```

### 5.3 VLAN Hopping / Unauthorized Access

#### Detection

```
Look for:
- Unusual traffic between VLANs
- Devices accessing resources outside VLAN
- Spanning tree topology changes
- Multiple MAC addresses on one port
```

#### Response

```
Secure VLAN:
  1. Remove unsecured ports
  2. Set native VLAN to unused VLAN
  3. Verify trunk configuration
  4. Check for rogue devices
  5. Review logs
```

---

## 6. VLAN MANAGEMENT

### 6.1 Adding New VLAN to Existing Network

#### Scenario: Add VLAN 80 (Support Team)

```
Step 1: Create VLAN on all switches
  Switch1# vlan 80
  Switch1(config-vlan)# name Support_Team
  Switch1(config-vlan)# exit

Step 2: Assign ports to VLAN 80
  Switch1# interface Fa0/15
  Switch1(config-if)# switchport access vlan 80
  Switch1(config-if)# no shutdown

Step 3: Configure router interface for VLAN 80
  Router# interface Fa0/1.80
  Router(config-subif)# encapsulation dot1Q 80
  Router(config-subif)# ip address 192.168.80.1 255.255.255.0
  Router(config-subif)# no shutdown

Step 4: Update trunk allowed VLANs
  Switch1# interface Gi0/1
  Switch1(config-if)# switchport trunk allowed vlan add 80

Step 5: Add static routes on all routers
  Router1# ip route 192.168.80.0 255.255.255.0 10.0.0.1

Step 6: Verify
  show vlan id 80
  show ip interface brief | include "Fa0/1.80"
  ping 192.168.80.1
```

### 6.2 Moving Device to Different VLAN

#### Scenario: Move PC from VLAN 10 to VLAN 20

```
Step 1: Note new IP for device
  VLAN 20 addresses: 192.168.20.1-254
  Assign: 192.168.20.4

Step 2: Change port VLAN on switch
  Switch# configure terminal
  Switch(config)# interface Fa0/1
  Switch(config-if)# switchport access vlan 20
  Switch(config-if)# exit

Step 3: Update device IP configuration
  Device > Settings > IP Configuration
  New IP: 192.168.20.4
  Gateway: 192.168.20.1
  Subnet: 255.255.255.0

Step 4: Verify
  Device pings gateway: 192.168.20.1
  Device pings server: 192.168.100.10
```

### 6.3 VLAN Naming Convention

#### Recommended Format

```
VLAN_ID: Department_Function

Examples:
VLAN 10: HR_Department
VLAN 20: IT_Department
VLAN 30: Sales_Department
VLAN 40: Operations_Branch1
VLAN 50: Operations_Branch2
VLAN 60: Support_Team
VLAN 70: Management_Network
VLAN 100: Server_VLAN

Benefits:
- Clear purpose
- Easy to find
- Scales well
- Professional appearance
```

### 6.4 VLAN Documentation

#### Required Documentation

```
File: docs/VLAN_INVENTORY.md

VLAN 10: HR_Department
  Location: Building A, Floor 2
  Devices: 3 PCs + 1 Printer
  Ports: Switch1 Fa0/1-3
  IP Range: 192.168.10.0/24
  Gateway: 192.168.10.1
  Server Access: Payroll DB, HR Files
  Created: 2025-12-06
  Last Updated: 2025-12-06
  Owner: HR Manager

VLAN 20: IT_Department
  Location: Building A, Floor 3
  Devices: 3 PCs + Monitoring System
  Ports: Switch1 Fa0/4-6
  IP Range: 192.168.20.0/24
  Gateway: 192.168.20.1
  Server Access: All servers
  Created: 2025-12-06
  Last Updated: 2025-12-06
  Owner: IT Manager

(Continue for all VLANs...)
```

---

## VLAN Configuration Checklist

### Pre-Implementation
- [ ] Determine VLAN scheme (which departments/functions)
- [ ] Assign VLAN IDs (10-99 for users)
- [ ] Plan IP addresses for each VLAN
- [ ] Document access requirements
- [ ] Plan router configuration

### Implementation
- [ ] Create VLANs on all switches
- [ ] Assign ports to VLANs
- [ ] Configure router interfaces
- [ ] Set up inter-VLAN routing
- [ ] Configure trunks between switches
- [ ] Test connectivity same VLAN
- [ ] Test connectivity cross VLAN
- [ ] Document all changes

### Post-Implementation
- [ ] Verify all devices connected to correct VLAN
- [ ] Test user access to required resources
- [ ] Verify server accessibility
- [ ] Check inter-VLAN communication
- [ ] Document final configuration
- [ ] Train support staff
- [ ] Monitor for issues

### Maintenance
- [ ] Review VLAN usage monthly
- [ ] Add new VLANs as needed
- [ ] Archive old configuration
- [ ] Test disaster recovery
- [ ] Update documentation

---

## Quick Reference: Common VLAN Commands

```bash
# Show all VLANs
show vlan brief

# Show specific VLAN
show vlan id 10

# Create VLAN
vlan 10
name HR_Department
exit

# Assign port to VLAN
interface Fa0/1
switchport access vlan 10
exit

# Configure trunk
interface Gi0/1
switchport mode trunk
switchport trunk allowed vlan 10,20,30
exit

# Show trunk info
show interface Gi0/1 trunk

# Show interface VLAN assignment
show interface Fa0/1 switchport

# Create sub-interface for routing
interface Fa0/1.10
encapsulation dot1Q 10
ip address 192.168.10.1 255.255.255.0
exit

# Show routing on sub-interfaces
show vlans
```

---

**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Production Ready  
**Last Updated**: 2025-12-06

---

## Additional Learning Resources

### Key Concepts to Master
- VLAN Tagging (802.1Q)
- Trunk Links
- Native VLAN
- Inter-VLAN Routing
- Access Control Lists
- Spanning Tree Protocol

### Recommended Certifications
- CompTIA Network+ (VLAN section)
- Cisco CCNA (VLAN design and implementation)
- Cisco CCNP (Advanced VLAN concepts)

### Troubleshooting Approach
1. Verify physical connections
2. Check VLAN assignments
3. Verify IP addresses and gateways
4. Test connectivity step by step
5. Review logs for errors
6. Consult documentation

