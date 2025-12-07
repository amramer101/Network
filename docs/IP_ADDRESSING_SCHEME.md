# IP Addressing Scheme - Complete Reference

## Network Address Planning

### Backbone Network (Core Infrastructure)
```
Network: 10.0.0.0/8 (Private - Class A)
Allocation: 10.0.0.0/16 for core backbone

Subnets:
┌────────────┬───────────────────┬──────────────────────┐
│ Device     │ IP Address        │ Subnet Mask          │
├────────────┼───────────────────┼──────────────────────┤
│ Router0 Fa0│ 10.0.0.1          │ 255.255.255.0        │
│ Router0 Fa1│ 10.0.0.2          │ 255.255.255.0        │
│ Router0 Fa2│ 10.0.0.3          │ 255.255.255.0        │
│ Router1 Fa0│ 10.0.1.1          │ 255.255.255.0        │
│ Router2 Fa0│ 10.0.2.1          │ 255.255.255.0        │
│ Router3 Fa0│ 10.0.3.1          │ 255.255.255.0        │
└────────────┴───────────────────┴──────────────────────┘
```

### Department VLANs (Branch 1)

**VLAN 10 - HR Department**
```
Network: 192.168.10.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.10.1
Router: Router1 (Fa0/1)
Switch: Switch1

IP Distribution:
  .1   - Router Gateway
  .2-9 - Reserved for future use
  .10-254 - Available for PCs/Devices
  .255 - Broadcast

Assigned IPs:
  PC1:  192.168.10.1
  PC2:  192.168.10.2
  PC3:  192.168.10.3
```

**VLAN 20 - IT Department**
```
Network: 192.168.20.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.20.1
Router: Router1 (Fa0/2)
Switch: Switch2

Assigned IPs:
  PC4:  192.168.20.1
  PC5:  192.168.20.2
  PC6:  192.168.20.3
```

**VLAN 30 - Sales Department**
```
Network: 192.168.30.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.30.1
Router: Router1 (Fa0/3)
Switch: Switch3

Assigned IPs:
  PC7:  192.168.30.1
  PC8:  192.168.30.2
  PC9:  192.168.30.3
```

### Department VLANs (Branch 2)

**VLAN 40 - Operations Group 1**
```
Network: 192.168.40.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.40.1
Router: Router2 (Fa0/1)
Switch: Switch4

Assigned IPs:
  PC10: 192.168.40.1
  PC11: 192.168.40.2
  PC12: 192.168.40.3
```

**VLAN 50 - Operations Group 2**
```
Network: 192.168.50.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.50.1
Router: Router2 (Fa0/2)
Switch: Switch5

Assigned IPs:
  PC13: 192.168.50.1
  PC14: 192.168.50.2
```

### Department VLANs (Branch 3)

**VLAN 60 - Support Team**
```
Network: 192.168.60.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.60.1
Router: Router3 (Fa0/1)
Switch: Switch6

Assigned IPs:
  PC15: 192.168.60.1
```

**VLAN 70 - Management**
```
Network: 192.168.70.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.70.1
Router: Router3 (Fa0/2)
Switch: Switch6

Assigned IPs:
  PC16: 192.168.70.1
```

**VLAN 100 - Server Network**
```
Network: 192.168.100.0/24
Subnet Mask: 255.255.255.0
Gateway: 192.168.100.1
Router: Router3 (Fa0/2)
Switch: Switch6

Assigned IPs:
  Server: 192.168.100.10
  Available: 192.168.100.11-254
```

---

## Subnet Calculations

### Class C Subnetting (255.255.255.0)
```
Subnet Mask: 255.255.255.0
Bits: /24
Host Bits: 8
Total Hosts per Subnet: 2^8 = 256
Usable Hosts: 254 (minus network and broadcast)

Example: 192.168.10.0/24
  Network Address: 192.168.10.0
  Broadcast Address: 192.168.10.255
  Usable IPs: 192.168.10.1 - 192.168.10.254
```

---

## IP Address Distribution Summary

```
Total Networks: 12
Total Subnets: 12
Total Usable IPs: 254 per subnet × 12 = 3,048
Total Used IPs: 24 (4 routers + 16 PCs + 1 Server + 3 Backbone links)
Utilization Rate: 0.79%
Available for Growth: 99.21%
```

---

## Routing Table Summary

### Static Route Configurations

**Router0 (Core) Routing Table:**
```
Destination    Subnet Mask        Gateway       Interface
10.0.0.0       255.255.255.0      Connected     Fa0/0
10.0.1.0       255.255.255.0      Connected     Fa0/1
10.0.2.0       255.255.255.0      Connected     Fa0/2
192.168.10.0   255.255.252.0      10.0.1.1      Fa0/0
192.168.20.0   255.255.252.0      10.0.1.1      Fa0/0
192.168.30.0   255.255.252.0      10.0.1.1      Fa0/0
192.168.40.0   255.255.252.0      10.0.2.1      Fa0/1
192.168.50.0   255.255.252.0      10.0.2.1      Fa0/1
192.168.60.0   255.255.252.0      10.0.3.1      Fa0/2
192.168.70.0   255.255.252.0      10.0.3.1      Fa0/2
192.168.100.0  255.255.255.0      10.0.3.1      Fa0/2
```

**Router1 (Branch1) Routing Table:**
```
Destination    Subnet Mask        Gateway       Interface
10.0.1.0       255.255.255.0      Connected     Fa0/0
192.168.10.0   255.255.255.0      Connected     Fa0/1
192.168.20.0   255.255.255.0      Connected     Fa0/2
192.168.30.0   255.255.255.0      Connected     Fa0/3
0.0.0.0        0.0.0.0            10.0.0.1      Fa0/0 (Default)
192.168.40.0   255.255.252.0      10.0.0.1      Fa0/0
192.168.60.0   255.255.252.0      10.0.0.1      Fa0/0
192.168.100.0  255.255.255.0      10.0.0.1      Fa0/0
```

---

## Address Reservation

### Reserved IPs by Design:
```
Router Interfaces (6):
  - Router0: 3 interfaces
  - Router1-3: 1 interface each on backbone, 2-3 on department VLANs

Default Gateways (8):
  - One per VLAN (10, 20, 30, 40, 50, 60, 70, 100)

Broadcast Addresses (12):
  - One per subnet (x.x.x.255)

Network Addresses (12):
  - One per subnet (x.x.x.0)
```

---

## Expansion Planning

### Available Address Space

```
Current Allocation:
  Used: 192.168.10.0/24 through 192.168.100.0/24 (8 networks)
  Available: 192.168.101.0 - 192.168.255.0 (155 networks)

Growth Capacity:
  Current Devices: 24
  Potential Expansion: 3,000+ additional devices
  
  Scenarios:
  - Add 5 new branches: 5 × 3 VLANs = 15 new VLANs possible
  - Add users per VLAN: 254 - 3 = 251 per VLAN
  - Add new services: 100+ possible new subnets
```

### Future VLAN Planning

```
Recommended New VLANs (if needed):
  VLAN200: Testing/Lab Network (192.168.200.0/24)
  VLAN210: Guest Network (192.168.210.0/24)
  VLAN220: IoT Devices (192.168.220.0/24)
  VLAN230: VoIP Network (192.168.230.0/24)
  VLAN240: Camera/Security (192.168.240.0/24)
```

---

## Subnet Mask Reference

```
Prefix  Subnet Mask          Hosts   Usage
/24     255.255.255.0        254     Departments, VLANs
/25     255.255.255.128      126     Sub-departments
/26     255.255.255.192      62      Teams
/27     255.255.255.224      30      Labs, Testing
/28     255.255.255.240      14      Small groups
/29     255.255.255.248      6       Point-to-point links
/30     255.255.255.252      2       Router links
/31     255.255.255.254      0       Special use
/32     255.255.255.255      1       Single hosts
```

---

## IP Allocation Quick Reference

```
Summary Table:
┌────────┬──────────────────┬──────────┬─────────────┬──────────────┐
│ VLAN   │ Network          │ Gateway  │ Devices     │ Type         │
├────────┼──────────────────┼──────────┼─────────────┼──────────────┤
│ 10     │ 192.168.10.0/24  │ .1      │ PC1-3       │ HR           │
│ 20     │ 192.168.20.0/24  │ .1      │ PC4-6       │ IT           │
│ 30     │ 192.168.30.0/24  │ .1      │ PC7-9       │ Sales        │
│ 40     │ 192.168.40.0/24  │ .1      │ PC10-12     │ Ops1         │
│ 50     │ 192.168.50.0/24  │ .1      │ PC13-14     │ Ops2         │
│ 60     │ 192.168.60.0/24  │ .1      │ PC15        │ Support      │
│ 70     │ 192.168.70.0/24  │ .1      │ PC16        │ Management   │
│ 100    │ 192.168.100.0/24 │ .1      │ Server      │ Servers      │
└────────┴──────────────────┴──────────┴─────────────┴──────────────┘
```

---

## Created: December 6, 2025
## Version: 1.0
## Status: Production Ready
