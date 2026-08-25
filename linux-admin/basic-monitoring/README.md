# Basic Monitoring # Using Linux In-built commands
A breif lab that documents native linux commands for system monitoring and troubleshooting including, storage, memory, network and logs to identify performance issues

### 1. top
Execute:
```bash
top
```
Purpose: Displays real-time active processes and system resource usage
Observations:
- Load average reflects CPU load over 1,5 and 15 minutes.
- task summary includes total, running, zombie, stopped etc
- %Cpu and %Mem shows high-usage processes


### 2. htop
install and execute: 
```bash
sudo apt install htop
htop
```
Purpose: Provides an interactive process viewer with visual representations of CPU per core, memmory, swap and processes-built on top

Observations:
- Color-coded process facilites analysis
- with usage of F-keys, enables quick identification of high-resource consumers and system load



### 3. vmstat
Execute:
```bash
vmstat 2 5
```

Purpose: reports info about processes, memory, paging, cpu activity etc at a given interval (2-secs, 5-reports)
Observation:
- Provides a snapshot of system performance over time


### 4. ps
Execute:
```bash
ps 
```
Purpose: list all runnning process in full details

Observation:
- can be used with grep to narrow the details down
- accepts flags
- supports user/service association


### 5. df
Execute:
```bash
df -h
```
Purpose: Displays disk space usage of mounted filesystems in human-readable format
Observation:
- Displays total, used and available
- shows partitions too


### 6. du
```bash
du -sh "diretory"
```
Purpose: Estimate file space usage

Observation:
- Displays total size of a directory and its subdirectories'


### 7. free
Execute:
```bash
free -h
```
Purpose: shows used and available memory in human-readable format
Observations:
- Asses RAM availability


### 8. uptime
Execute:
```bash
uptime
```
Purpose: Displays how long the system has been running along with load averages
Observation:
- Useful for determining system stability and performance trends
- indicates runtime

### 9. netstat
Execute:
```bash
netstat -tuln
```
purpose: to investigate sockets, ports, connections etc
Observation:
- Identifies active services and ports
- similar to SS

### 10. lsof
Execute:
```bash
lsof -i :22
```
Purpose: List open files and network connections for debugging

Observations:
- reveals processes bound to a port

### 11. journalctl
Execute:
```bash
journalctl -xe | less
```
purpose: Views logs and explanations, paginated

Observations: 
- logs error,warnings and events
- aids analysis