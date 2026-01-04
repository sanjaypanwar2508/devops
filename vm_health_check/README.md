# VM Health Check Script

A shell script that monitors the health of Ubuntu virtual machines by analyzing CPU, memory, and disk usage.

## Overview
This script monitors the health of Ubuntu virtual machines by checking CPU, memory, and disk usage against a 60% threshold.

## Health Criteria
- **HEALTHY**: All resources (CPU, Memory, Disk) are below 60% utilization
- **NOT HEALTHY**: Any resource exceeds 60% utilization

## Usage

### Basic Usage
Run the script without arguments to get a simple health status:

```bash
./vm_health_check.sh
```

**Example Output:**
```
==================================
   VM HEALTH CHECK REPORT
==================================

Health Status: HEALTHY

==================================
```

### Detailed Explanation Mode
Run with the `explain` argument to see detailed metrics and reasons:

```bash
./vm_health_check.sh explain
```

**Example Output (Healthy):**
```
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

**Example Output (Not Healthy):**
```
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

## Exit Codes
- `0`: VM is healthy
- `1`: VM is not healthy

This allows integration with monitoring systems:
```bash
./vm_health_check.sh
if [ $? -eq 0 ]; then
    echo "System is running normally"
else
    echo "System requires attention!"
fi
```

## Prerequisites
The script requires these common Ubuntu utilities:
- `top` - for CPU usage
- `free` - for memory usage
- `df` - for disk usage
- `bc` - for floating-point calculations

Install if missing:
```bash
sudo apt-get update
sudo apt-get install -y bc procps coreutils
```

## Automation
You can schedule this script using cron for regular monitoring:

```bash
# Check VM health every 5 minutes and log results
*/5 * * * * /path/to/vm_health_check.sh explain >> /var/log/vm_health.log 2>&1
```

## Customization
To change the threshold, edit the `THRESHOLD` variable in the script:
```bash
THRESHOLD=60  # Change this value as needed
```
