# Container Monitoring System

## Description

A Docker-based monitoring system that tracks CPU, memory usage, and application logs of a containerized Java application. The monitor container connects to the app container via SSH and reports metrics at configurable intervals.

### Technologies

- **Docker & Docker Compose** - Container orchestration
- **Bash** - Monitoring script automation
- **SSH** - Secure inter-container communication
- **Ubuntu 24.04** - Base container OS
- **Java** - Application runtime

### Architecture

The system consists of two containers:
- **app** - Java application server with SSH access
- **monitor** - Monitoring service that collects metrics remotely

## Running the Project

### Prerequisites

- Docker and Docker Compose installed
- Make the deployment script executable: `chmod +x deploy.sh`

### Deployment Commands

```bash
./deploy.sh provision   # Build images and create containers
./deploy.sh start       # Start all containers
./deploy.sh status      # Check container status
./deploy.sh monitor     # View live monitoring logs
./deploy.sh stop        # Stop containers
./deploy.sh teardown    # Remove containers and images
```

### Quick Start

```bash
./deploy.sh provision
./deploy.sh start
./deploy.sh monitor
```

## Configuration

Edit `monitor/monitor.conf` to customize monitoring behavior:

- **ReportTime** - Interval between periodic reports (minutes)
- **CpuThreshold** - CPU usage threshold for spike alerts (%)
- **MemoryThreshold** - Memory usage threshold for spike alerts (%)

## Monitoring Output

The monitoring system provides:

- **Periodic Reports** - Average CPU/memory usage and log statistics at configured intervals
- **Spike Alerts** - Immediate notifications when thresholds are exceeded
- **Log Analysis** - Count of warnings and errors since last report

## Network

Both containers run on an isolated `monitoring-network` bridge network. The app container exposes SSH on port 2222 for external access if needed.
