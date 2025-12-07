# Network Troubleshooting Guide

## Common Network Issues & Solutions

---

## 🔴 ISSUE 1: PCs in Same VLAN Can't Ping Each Other

### Symptoms
```
From PC1:
$ ping 192.168.10.2
PING 192.168.10.2 (192.168.10.2) 56(84) bytes of data.
100% packet loss
```

### Root Causes & Solutions

#### 1.1 Wrong VLAN Assignment
**Problem**: PC connected to wrong VLAN port

**Check**:
```
Click Switch1 > CLI
show vlan brief

PC Port  | VLAN Status
Fa0/1    | 10    active
Fa0/2    | 10    active
Fa0/3    | 20    active  ← PROBLEM!
```

**Solution**:
```
configure terminal
interface FastEthernet0/3
switchport access vlan 10
no shutdown
exit
end
```

#### 1.2 Switch Port Not Enabled
**Problem**: Port is administratively shutdown

**Check**:
```
Click Switch1 > CLI
show interface status

Port     | Status
Fa0/1    | connected
Fa0/2    | disabled ← PROBLEM!
Fa0/3    | connected
```

**Solution**:
```
configure terminal
interface FastEthernet0/2
no shutdown
exit
end
```

#### 1.3 PC IP Configuration Error
**Problem**: PC has wrong IP address or gateway

**Check**: 
- Click PC1 > Desktop tab > IP Configuration
- Verify IP: 192.168.10.1 ✓
- Verify Gateway: 192.168.10.1 ✓
- Verify Subnet: 255.255.255.0 ✓

**Solution**:
```
If incorrect, update IP settings in PC
Click PC1 > Desktop > IP Configuration
Set correct values
```

#### 1.4 Switch Not Configured
**Problem**: Switch doesn't have VLAN configured

**Check**:
```
Click Switch1 > CLI
show vlan brief

VLAN Name                             Status    Ports
---- -------------------------------- --------- ------------------------
1    default                          active    Fa0/1, Fa0/2, Fa0/3, Gi0/1
```

**Solution**: Configure VLAN first
```
configure terminal
vlan 10
name HR_Department
exit
interface FastEthernet0/1
switchport access vlan 10
exit
end
```

---

## 🔴 ISSUE 2: Cross-VLAN Communication Fails

### Symptoms
```
From PC1 (VLAN10):
$ ping 192.168.20.1 (VLAN20)
No response / Unreachable
```

### Root Causes & Solutions

#### 2.1 Router Not Configured with VLAN Interface
**Problem**: Router interface for VLAN missing

**Check**:
```
Click Router1 > CLI
show ip interface brief

Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            10.0.1.1        YES manual up                    up
FastEthernet0/1            192.168.10.1    YES manual up                    up
FastEthernet0/2            unassigned      NO  unset  administratively down  down
```

**Solution**:
```
configure terminal
interface FastEthernet0/2
ip address 192.168.20.1 255.255.255.0
no shutdown
exit
end
```

#### 2.2 Router-to-Switch Connection Not Proper
**Problem**: Wrong port or connection type

**Check**:
- Verify physical connection (should be green)
- Verify correct interfaces connected
- Verify no speed mismatch

**Solution**:
- Reconnect cables properly
- Use matching port types (Fa to Fa, Gi to Gi)

#### 2.3 Wrong Routing Configuration
**Problem**: No route between VLANs

**Check**:
```
Click Router1 > CLI
show ip route

Output should show:
C    192.168.10.0/24 is directly connected, FastEthernet0/1
C    192.168.20.0/24 is directly connected, FastEthernet0/2
```

**Solution**: Check all interfaces configured
```
show ip interface brief
(All should show "up up" status)
```

#### 2.4 Switch Configured as Trunk Instead of Access
**Problem**: Switch port treating VLAN traffic incorrectly

**Check**:
```
Click Switch > CLI
show interface Fa0/1 switchport

Switchport: Enabled
Administrative Mode: trunk ← PROBLEM for access port!
```

**Solution**:
```
configure terminal
interface FastEthernet0/1
switchport mode access
switchport access vlan 10
no shutdown
exit
end
```

---

## 🔴 ISSUE 3: Can't Access Central Server

### Symptoms
```
From any PC:
$ ping 192.168.100.10
No response / Request timed out
```

### Root Causes & Solutions

#### 3.1 Server Not Connected to Network
**Problem**: Server device not physically connected

**Check**:
- Look for physical connection (should be green line)
- Verify connected to Switch6 Gi0/1
- Check connection status indicator

**Solution**:
- Connect Server to Switch6 Gi0/1 port
- Ensure connection shows green/active

#### 3.2 Server IP Configuration Wrong
**Problem**: Server has incorrect IP address

**Check**:
```
Click Server > Desktop > IP Configuration

Should show:
IPv4 Address: 192.168.100.10 ✓
Subnet Mask: 255.255.255.0 ✓
Default Gateway: 192.168.100.1 ✓
```

**Solution**: Set correct IP settings
```
Server > Desktop > IP Configuration
IPv4 Address: 192.168.100.10
Subnet Mask: 255.255.255.0
Default Gateway: 192.168.100.1
```

#### 3.3 VLAN100 Not Configured on Switch6
**Problem**: VLAN100 doesn't exist on server switch

**Check**:
```
Click Switch6 > CLI
show vlan brief

VLAN Name                             Status    Ports
---- -------------------------------- --------- ------------------------
60   Support_Team                    active    Fa0/1
70   Management                       active    Fa0/2
100  Server_VLAN                      active    Gi0/1 ← Should be here
```

**Solution**:
```
configure terminal
vlan 100
name Server_VLAN
exit
interface GigabitEthernet0/1
switchport access vlan 100
no shutdown
exit
end
```

#### 3.4 No Route to Server VLAN
**Problem**: Router doesn't know how to reach 192.168.100.0/24

**Check**:
```
From Router1 > CLI:
show ip route

Should include:
S    192.168.100.0/24 [1/0] via 10.0.0.1
```

**Solution**: Add static route on Router1
```
configure terminal
ip route 192.168.100.0 255.255.255.0 10.0.0.1
exit
end
```

#### 3.5 Core Router Doesn't Route to Server VLAN
**Problem**: Router0 missing server network route

**Check**:
```
Click Router0 > CLI
show ip route

Missing: 192.168.100.0/24 via Router3
```

**Solution**:
```
configure terminal
ip route 192.168.100.0 255.255.255.0 10.0.3.1
exit
end
```

---

## 🔴 ISSUE 4: Inter-Branch Communication Fails

### Symptoms
```
From PC1 (Branch1):
$ ping 192.168.40.1 (Branch2)
Unreachable
```

### Root Causes & Solutions

#### 4.1 Backbone Links Not Connected
**Problem**: Routers not physically connected

**Check**:
- Verify green connection lines between routers
- Check: Router1 connected to Router0
- Check: Router2 connected to Router0
- Check: Router3 connected to Router0

**Solution**:
- Connect routers using appropriate ports
- Router backbone uses: 10.0.0.0/24 network

#### 4.2 Router Interface Not Configured
**Problem**: Backbone interface has no IP

**Check**:
```
Click Router0 > CLI
show ip interface brief

Interface                  IP-Address      Status
FastEthernet0/0            10.0.0.1        up
FastEthernet0/1            10.0.0.2        up
FastEthernet0/2            10.0.0.3        up ← All should have IPs
```

**Solution**:
```
Click Router0 > CLI
configure terminal
interface FastEthernet0/2
ip address 10.0.0.3 255.255.255.0
no shutdown
exit
end
```

#### 4.3 No Route Between Branches
**Problem**: Static routes not configured

**Check**:
```
Click Router1 > CLI
show ip route

Should have default route:
S*   0.0.0.0/0 [1/0] via 10.0.0.1
```

**Solution**: Configure default route on branch routers
```
configure terminal
ip route 0.0.0.0 0.0.0.0 10.0.0.1
exit
end
```

#### 4.4 Wrong Subnet Mask
**Problem**: Backbone subnet masks don't match

**Check**:
```
Router0 Fa0/1: 10.0.0.1 255.255.255.0 ✓
Router1 Fa0/0: 10.0.1.1 255.255.255.0 ✓
Router2 Fa0/0: 10.0.2.1 255.255.255.0 ✓
```

**Solution**: Ensure all use /24 subnet (255.255.255.0)

---

## 🟡 ISSUE 5: Slow Network Performance

### Symptoms
- High latency (>100ms)
- Packet loss
- Timeouts

### Root Causes & Solutions

#### 5.1 Network Congestion
**Problem**: Too much traffic on one link

**Check**:
- Look for high utilization in simulation
- Check for broadcast storms
- Look for duplicate traffic

**Solution**:
- Use Quality of Service (QoS)
- Implement traffic shaping
- Check for loops (add Spanning Tree)

#### 5.2 Default Route Loop
**Problem**: Packets circulating infinitely

**Check**:
```
tracert 192.168.100.10
(Shows excessive hops or repeating IPs)
```

**Solution**:
- Verify static routes are correct
- Check no conflicting routes
- Use: show ip route for verification

---

## 🟡 ISSUE 6: DNS Not Working

### Symptoms
```
$ nslookup company.local
DNS request failed
```

### Root Causes & Solutions

#### 6.1 DNS Server Not Running
**Problem**: Server DNS service not enabled

**Check**: 
```
Click Server > Services tab
Look for DNS - should show green (running)
```

**Solution**:
```
Click Server > Services
Enable DNS service
```

#### 6.2 PC DNS Configuration Wrong
**Problem**: PC pointing to wrong DNS server

**Check**:
```
Click PC > Desktop > IP Configuration
DNS Server should be: 192.168.100.10
```

**Solution**:
```
Update DNS to: 192.168.100.10
```

---

## 📊 Diagnostic Commands

### Essential Cisco Commands

#### Information Gathering
```bash
# Show running configuration
show running-config

# Show interface status
show ip interface brief

# Show VLAN information
show vlan brief

# Show routing table
show ip route

# Show specific interface details
show interface FastEthernet0/1

# Show IP address on interface
show ip address

# Show MAC address table
show mac-address-table
```

#### Connectivity Testing
```bash
# Test reachability
ping 192.168.10.1

# Trace route to destination
tracert 192.168.10.1

# Show interface status
show interfaces status

# Show connected devices
show ip neighbor
```

---

## ✅ Quick Verification Checklist

### Before Testing
- [ ] All physical connections in place (green lines)
- [ ] All routers have 3 active interfaces
- [ ] All switches have VLANs configured
- [ ] All PCs have correct IP addresses
- [ ] Server connected and configured
- [ ] All interfaces set to "no shutdown"

### Connectivity Verification
- [ ] Same VLAN: PCs can ping each other
- [ ] Cross-VLAN: PCs can ping through router
- [ ] Server: Accessible from all VLANs
- [ ] Inter-branch: Branch1 ↔ Branch2 ↔ Branch3
- [ ] Internet: Default route works

### Configuration Verification
- [ ] All routers have hostnames
- [ ] All switches have hostnames
- [ ] VLANs named properly
- [ ] Default gateways configured
- [ ] Static routes on all routers
- [ ] IP addresses unique and in correct subnet

---

## 🔧 Recovery Procedures

### Reset Network
```
# On each router
configure terminal
default interface all
exit

# Or delete specific configuration
no ip route 0.0.0.0 0.0.0.0 10.0.0.1
```

### Restore from Backup
```
# If using saved configuration
copy flash:config.backup running-config
```

### Emergency Procedures
1. Note down all current configurations
2. Save to file
3. Make changes one device at a time
4. Test after each change
5. Document any issues

---

## 📞 When All Else Fails

1. **Double-check IP addresses** - Most common issue
2. **Verify VLAN assignments** - Second most common
3. **Check physical connections** - Look for green lines
4. **Review subnet masks** - Must be /24 (255.255.255.0)
5. **Verify gateway settings** - Should match router interface
6. **Test simple connectivity first** - Then work up to complex
7. **Use ping systematically** - Same VLAN → Cross VLAN → Server
8. **Check routing table** - Use: show ip route
9. **Verify no shutdown** - All interfaces must be active
10. **Save configuration** - Use: write memory

---

## Advanced Diagnostics

### Packet Capture
```
# (If available in Packet Tracer)
Click simulation tab
Add PDU (Packet Delivery Understanding)
Send packet and observe path
```

### Debug Output
```
# Enable debugging
debug ip routing
debug ip packet

# Show debug output
show debug

# Disable debugging
undebug all
```

---

## Performance Metrics

### Baseline (Good Network)
- Ping response: 1-5ms (same VLAN)
- Ping response: 5-10ms (cross VLAN)
- Ping response: 10-20ms (inter-branch)
- Packet loss: 0%
- Response time: <100ms

### Warning Signs
- Ping response: >50ms
- Packet loss: >5%
- Intermittent connectivity
- Slow file transfers

### Critical Issues
- Ping response: >100ms
- Packet loss: >10%
- Complete inability to connect
- Broadcast storms

---

## Support Resources

### Cisco Documentation
- Configuration guides
- Troubleshooting manuals
- Best practices

### Network Concepts
- TCP/IP fundamentals
- Routing basics
- VLAN concepts

### Tools
- Ping utility
- Tracert (traceroute)
- ipconfig (IP configuration)
- Show commands

---

**Created**: December 6, 2025  
**Version**: 1.0  
**Status**: Production Ready

---

### Emergency Quick Reference

```
Can't Ping Same VLAN?
  1. Check VLAN assignment on switch port
  2. Check PC IP is in same subnet
  3. Check switch has VLAN configured
  4. Check port is not shutdown

Can't Ping Different VLAN?
  1. Check router interface for that VLAN
  2. Check static routes on router
  3. Check interface is not shutdown
  4. Check gateway on PC

Can't Access Server?
  1. Check server IP: 192.168.100.10
  2. Check server connected to Switch6
  3. Check VLAN100 exists on Switch6
  4. Check route to 192.168.100.0/24

Can't Access Other Branch?
  1. Check backbone connections (10.0.x.0)
  2. Check router interfaces have IPs
  3. Check static route to other branch
  4. Check default route points to core
```
