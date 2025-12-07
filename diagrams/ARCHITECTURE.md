# Cisco Packet Tracer - Network Architecture Design

## 📊 Network Topology Overview

```
                        ┌─────────────────────────────────────────┐
                        │         INTERNET CLOUD                   │
                        │         (ISP Gateway)                    │
                        └──────────────────┬──────────────────────┘
                                           │
                                    ┌──────┴──────┐
                                    │   Router0   │
                                    │  (Core      │
                                    │   Router)   │
                                    └──────┬──────┘
                                           │
                    ┌──────────────────────┼──────────────────────┐
                    │                      │                      │
              ┌─────┴────┐           ┌─────┴────┐           ┌─────┴────┐
              │ Router1   │           │ Router2  │           │ Router3  │
              │ (Branch1) │           │(Branch2) │           │(Branch3) │
              └─────┬────┘           └─────┬────┘           └─────┬────┘
                    │                      │                      │
        ┌───────────┼───────────┐      ┌───┴────┐            ┌────┴─────┐
        │           │           │      │        │            │          │
    ┌───┴───┐  ┌───┴───┐  ┌───┴───┐ ┌──┴───┐ ┌─┴────┐   ┌──┴───┐  ┌──┴────┐
    │Switch1│  │Switch2│  │Switch3│ │Sw-B2 │ │Sw-B2 │   │Sw-B3 │  │ Srv   │
    │(VLAN) │  │(VLAN) │  │(VLAN) │ │ -1  │ │ -2  │   │ -1  │  │Server │
    └───┬───┘  └───┬───┘  └───┬───┘ └──┬───┘ └─┬────┘   └──┬───┘  └───┬───┘
        │          │          │        │       │           │          │
    ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐  ├─┐ ┌─┐ ├─┐ ┌─┐ ├─┐ ┌─┐     ├─┐ ┌─┐     │
    │P│ │P│ │P│ │P│ │P│ │P│  │P│ │P│ │P│ │P│ │P│ │P│     │P│ │P│     │
    │C│ │C│ │C│ │C│ │C│ │C│  │C│ │C│ │C│ │C│ │C│ │C│     │C│ │C│     │
    │1│ │2│ │3│ │4│ │5│ │6│  │7│ │8│ │9│ │10│ │11│ │12│    │13│ │14│    │
    └─┘ └─┘ └─┘ └─┘ └─┘ └─┘  └─┘ └─┘ └─┘ └─┘ └─┘ └─┘    └─┘ └─┘    │
    VLAN10  VLAN20  VLAN30  VLAN40 VLAN50 VLAN60  VLAN70  Server(192.168.100.10)
    (HR)    (IT)    (Sales) (Ops1) (Ops2) (Support)(Mgmt)  
```

## 🏢 Network Components

### Layer 1: Core Infrastructure
- **Router0 (ISP Gateway)**: Primary router connecting to internet
  - IP: 10.0.0.1/24
  - Gateway for all branches

### Layer 2: Branch Routers
- **Router1 (Branch1)**
  - IP: 10.0.1.1/24
  - Connects Switch1, Switch2, Switch3
  
- **Router2 (Branch2)**
  - IP: 10.0.2.1/24
  - Connects Switch4, Switch5
  
- **Router3 (Branch3)**
  - IP: 10.0.3.1/24
  - Connects Switch6 + Server

### Layer 3: Switches (VLAN Configured)
- **Switch1-3 (Branch1)**: Manage VLAN10, VLAN20, VLAN30
- **Switch4-5 (Branch2)**: Manage VLAN40, VLAN50
- **Switch6 (Branch3)**: Manage VLAN60, VLAN70

### Layer 4: End Devices
- **PCs (14 total)**: Connected to switches
- **Server**: Database/Web server

---

## 📋 VLAN Configuration

```
┌─────────┬──────────────────┬─────────────────┬─────────────────┐
│ VLAN ID │   VLAN Name      │   IP Subnet     │   Description   │
├─────────┼──────────────────┼─────────────────┼─────────────────┤
│  VLAN10 │   HR Department  │  192.168.10.0/24│   Human Res.    │
│  VLAN20 │   IT Department  │  192.168.20.0/24│   Information   │
│  VLAN30 │   Sales Dept.    │  192.168.30.0/24│   Sales Team    │
│  VLAN40 │   Operations 1   │  192.168.40.0/24│   Ops Dept 1    │
│  VLAN50 │   Operations 2   │  192.168.50.0/24│   Ops Dept 2    │
│  VLAN60 │   Support Team   │  192.168.60.0/24│   Tech Support  │
│  VLAN70 │   Management     │  192.168.70.0/24│   Admin Layer   │
│ VLAN100 │   Server VLAN    │  192.168.100.0/24│  Servers        │
└─────────┴──────────────────┴─────────────────┴─────────────────┘
```

---

## 🔗 Routing Strategy

### Static Routing
```
Branch1 (Router1)
├── Route to Branch2: 10.0.2.0/24 via 10.0.0.2
├── Route to Branch3: 10.0.3.0/24 via 10.0.0.3
└── Default Route: 0.0.0.0/0 via 10.0.0.1

Branch2 (Router2)
├── Route to Branch1: 10.0.1.0/24 via 10.0.0.1
├── Route to Branch3: 10.0.3.0/24 via 10.0.0.3
└── Default Route: 0.0.0.0/0 via 10.0.0.1

Branch3 (Router3)
├── Route to Branch1: 10.0.1.0/24 via 10.0.0.1
├── Route to Branch2: 10.0.2.0/24 via 10.0.0.2
└── Default Route: 0.0.0.0/0 via 10.0.0.1
```

---

## 🖥️ IP Addressing Scheme

### Router Layer
```
Router0 (ISP):          10.0.0.1/24
Router1 (Branch1):      10.0.1.1/24
Router2 (Branch2):      10.0.2.1/24
Router3 (Branch3):      10.0.3.1/24
```

### PC Addressing by Department
```
VLAN10 (HR):            192.168.10.1-10
VLAN20 (IT):            192.168.20.1-10
VLAN30 (Sales):         192.168.30.1-10
VLAN40 (Ops1):          192.168.40.1-10
VLAN50 (Ops2):          192.168.50.1-10
VLAN60 (Support):       192.168.60.1-10
VLAN70 (Management):    192.168.70.1-10
Server:                 192.168.100.10/24
```

---

## 🔐 Security Features

1. **VLAN Isolation**: Each department in separate VLAN
2. **Access Control**: Routers restrict inter-VLAN traffic
3. **Router Filtering**: Prevent unauthorized access
4. **Server Protection**: Dedicated VLAN100 for servers
5. **Management Access**: Separate VLAN70 for admins

---

## 📡 Network Services

1. **DHCP**: Automatic IP assignment (if configured)
2. **DNS**: Server provides domain resolution
3. **HTTP/HTTPS**: Web services on server
4. **SSH**: Secure management access
5. **ICMP**: Ping for connectivity testing

---

## ✅ Testing Scenarios

1. **Intra-VLAN Communication**: PCs in same VLAN can communicate
2. **Inter-VLAN Communication**: Through router with proper configuration
3. **Server Access**: All VLANs can access server
4. **Internet Access**: Default route to ISP gateway
5. **Branch-to-Branch**: Routers communicate through core

---

## 📊 Network Statistics

- **Total Routers**: 3
- **Total Switches**: 6
- **Total VLANs**: 8
- **Total PCs**: 14
- **Total Servers**: 1
- **Total Devices**: 24
- **Subnets**: 7
- **Bandwidth**: 1000 Mbps (Gigabit)

---

## 🚀 Deployment Steps

1. Create topology in Cisco Packet Tracer
2. Configure Router IPs
3. Configure Switch VLANs
4. Configure PC IP addresses
5. Setup static routes
6. Enable inter-VLAN routing
7. Test connectivity with ping
8. Verify VLAN isolation
9. Enable server services
10. Document all configurations

---

**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Production Ready
