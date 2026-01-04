# VM Health Check

A comprehensive shell script for monitoring Ubuntu virtual machine health based on CPU, memory, and disk usage.

## Overview

This script analyzes the health of your Ubuntu VM by checking three critical system metrics:
- **CPU Usage**: Current CPU utilization percentage
- **Memory Usage**: Current memory utilization percentage
- **Disk Usage**: Current disk space utilization percentage

## Health Status Criteria

- **HEALTHY**: All resources are below 60% utilization
- **NOT HEALTHY**: Any resource exceeds 60% utilization

## Quick Start

```bash
# Basic health check
./vm_health_check.sh

# Detailed health check with explanations and recommendations
./vm_health_check.sh explain
```

## Usage Examples

### Basic Check
```bash
$ ./vm_health_check.sh

==================================
   VM HEALTH CHECK REPORT
==================================

Health Status: HEALTHY

==================================
```

### Detailed Check (Healthy System)
```bash
$ ./vm_health_check.sh explain

==================================
   VM HEALTH CHECK REPORT
==================================

Current System Metrics:
  CPU Usage:    25.3%
  Memory Usage: 45.67%
  Disk Usage:   52%

Threshold:      60%

Health Status: HEALTHY

Reason: All system resources are within acceptable limits.
  ✓ CPU usage (25.3%) is below 60%
  ✓ Memory usage (45.67%) is below 60%
  ✓ Disk usage (52%) is below 60%

==================================
```

### Detailed Check (Unhealthy System)
```bash
$ ./vm_health_check.sh explain

==================================
   VM HEALTH CHECK REPORT
==================================

Current System Metrics:
  CPU Usage:    75.8%
  Memory Usage: 45.67%
  Disk Usage:   85%

Threshold:      60%

Health Status: NOT HEALTHY

Reason: One or more system resources exceed the 60% threshold.

Issues detected:
  ✗ CPU usage is 75.8% (exceeds 60% threshold)
  ✗ Disk usage is 85% (exceeds 60% threshold)

Recommendations:
  - Investigate high CPU processes using: top or htop
  - Consider upgrading CPU resources or optimizing applications
  - Free up disk space by removing unused files
  - Use 'du -sh /* 2>/dev/null | sort -h' to find large directories
  - Consider expanding disk capacity

==================================
```

## Features

- **Color-coded output**: Green for healthy, red for unhealthy status
- **Exit codes**: Returns 0 for healthy, 1 for unhealthy (useful for automation)
- **Detailed explanations**: Optional `explain` argument provides comprehensive diagnostics
- **Actionable recommendations**: Specific suggestions for resolving each issue
- **Ubuntu optimized**: Built for Ubuntu systems with commonly available tools

## Exit Codes

- `0`: VM is healthy (all resources below 60%)
- `1`: VM is not healthy (any resource at or above 60%)

## Integration with Monitoring Systems

The exit codes allow easy integration with monitoring solutions:

```bash
./vm_health_check.sh
if [ $? -eq 0 ]; then
    echo "System is running normally"
else
    echo "System requires attention!"
fi
```

## Cron Scheduling

Automate health checks with cron:

```bash
# Check VM health every 5 minutes and log results
*/5 * * * * /path/to/vm_health_check.sh explain >> /var/log/vm_health.log 2>&1
```

## Prerequisites

The script requires these standard Ubuntu utilities:

- `top` - for CPU usage analysis
- `free` - for memory information
- `df` - for disk space information
- `bc` - for floating-point calculations
- Standard Unix tools: `grep`, `awk`, `cut`, `sed`

Most are pre-installed on Ubuntu. Install missing dependencies:

```bash
sudo apt-get update
sudo apt-get install -y bc procps coreutils
```

## Customization

### Change Threshold

Edit the `THRESHOLD` variable in the script:

```bash
THRESHOLD=70  # Change from 60 to 70 percent
```

## Requirements

- Ubuntu 16.04 or later
- Bash shell
- Root or sudo access (for top command)

## License

Open source and free to use.

## Notes

- The script measures root partition (`/`) disk usage. Adjust the script if monitoring specific partitions is needed.
- CPU usage is sampled over 1 second for accuracy.
- Memory usage is calculated as used/total RAM.
- All percentages are rounded to 2 decimal places for memory, and whole numbers for CPU/disk.
