#!/bin/bash

# VM Health Check Script for Ubuntu
# Checks CPU, Memory, and Disk usage against 60% threshold

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to get CPU usage percentage
get_cpu_usage() {
    # Get CPU usage using top command (1 second sample)
    cpu_usage=$(top -bn2 -d 0.5 | grep "Cpu(s)" | tail -n 1 | awk '{print $2}' | cut -d'%' -f1)
    echo "$cpu_usage"
}

# Function to get Memory usage percentage
get_memory_usage() {
    # Get memory usage using free command
    memory_usage=$(free | grep Mem | awk '{printf "%.2f", ($3/$2) * 100}')
    echo "$memory_usage"
}

# Function to get Disk usage percentage
get_disk_usage() {
    # Get disk usage for root partition
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "$disk_usage"
}

# Threshold value
THRESHOLD=60

# Get current usage values
CPU=$(get_cpu_usage)
MEMORY=$(get_memory_usage)
DISK=$(get_disk_usage)

# Initialize health status
IS_HEALTHY=true
ISSUES=()

# Check CPU usage
if (( $(echo "$CPU > $THRESHOLD" | bc -l) )); then
    IS_HEALTHY=false
    ISSUES+=("CPU usage is ${CPU}% (exceeds ${THRESHOLD}% threshold)")
fi

# Check Memory usage
if (( $(echo "$MEMORY > $THRESHOLD" | bc -l) )); then
    IS_HEALTHY=false
    ISSUES+=("Memory usage is ${MEMORY}% (exceeds ${THRESHOLD}% threshold)")
fi

# Check Disk usage
if (( $(echo "$DISK > $THRESHOLD" | bc -l) )); then
    IS_HEALTHY=false
    ISSUES+=("Disk usage is ${DISK}% (exceeds ${THRESHOLD}% threshold)")
fi

# Print results
echo "=================================="
echo "   VM HEALTH CHECK REPORT"
echo "=================================="
echo ""

if [ "$1" = "explain" ]; then
    echo "Current System Metrics:"
    echo "  CPU Usage:    ${CPU}%"
    echo "  Memory Usage: ${MEMORY}%"
    echo "  Disk Usage:   ${DISK}%"
    echo ""
    echo "Threshold:      ${THRESHOLD}%"
    echo ""
fi

# Display health status
if [ "$IS_HEALTHY" = true ]; then
    echo -e "Health Status: ${GREEN}HEALTHY${NC}"

    if [ "$1" = "explain" ]; then
        echo ""
        echo "Reason: All system resources are within acceptable limits."
        echo "  ✓ CPU usage (${CPU}%) is below ${THRESHOLD}%"
        echo "  ✓ Memory usage (${MEMORY}%) is below ${THRESHOLD}%"
        echo "  ✓ Disk usage (${DISK}%) is below ${THRESHOLD}%"
    fi
else
    echo -e "Health Status: ${RED}NOT HEALTHY${NC}"

    if [ "$1" = "explain" ]; then
        echo ""
        echo "Reason: One or more system resources exceed the ${THRESHOLD}% threshold."
        echo ""
        echo "Issues detected:"
        for issue in "${ISSUES[@]}"; do
            echo "  ✗ $issue"
        done

        echo ""
        echo "Recommendations:"
        if (( $(echo "$CPU > $THRESHOLD" | bc -l) )); then
            echo "  - Investigate high CPU processes using: top or htop"
            echo "  - Consider upgrading CPU resources or optimizing applications"
        fi
        if (( $(echo "$MEMORY > $THRESHOLD" | bc -l) )); then
            echo "  - Check memory-intensive processes using: free -h and top"
            echo "  - Consider increasing RAM or optimizing memory usage"
        fi
        if (( $(echo "$DISK > $THRESHOLD" | bc -l) )); then
            echo "  - Free up disk space by removing unused files"
            echo "  - Use 'du -sh /* 2>/dev/null | sort -h' to find large directories"
            echo "  - Consider expanding disk capacity"
        fi
    fi
fi

echo ""
echo "=================================="

# Exit with appropriate code
if [ "$IS_HEALTHY" = true ]; then
    exit 0
else
    exit 1
fi
