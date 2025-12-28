#!/bin/bash
set -e

CONF_FILE="monitor.conf"
LOG_FILE="/app/app.log"
LAST_LOG_LINE=0

parse_config() {
    while IFS='=' read -r key value; do
        case "$key" in
            ReportTime) REPORT_TIME=$value ;;
            CpuThreshold) CPU_THRESHOLD=$value ;;
            MemoryThreshold) MEMORY_THRESHOLD=$value ;;
        esac
    done < "$CONF_FILE"
}

get_cpu_usage() {
    ssh server "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - \$1}'"
}

get_memory_usage() {
    ssh server "free | grep Mem | awk '{print (\$3/\$2) * 100.0}'"
}

count_log_entries() {
    local pattern=$1
    local count=$(ssh server "tail -n +$((LAST_LOG_LINE + 1)) $LOG_FILE 2>/dev/null | grep -c '$pattern' || echo 0")
    echo $count
}

update_last_log_line() {
    LAST_LOG_LINE=$(ssh server "wc -l < $LOG_FILE 2>/dev/null || echo 0")
}

parse_config

REPORT_INTERVAL=$((REPORT_TIME * 60))
CHECK_INTERVAL=60

cpu_sum=0
mem_sum=0
check_count=0
last_report_time=$(date +%s)

update_last_log_line

while true; do
    cpu=$(get_cpu_usage)
    mem=$(get_memory_usage)
    
    cpu_int=${cpu%.*}
    mem_int=${mem%.*}
    
    if [ "$cpu_int" -gt "$CPU_THRESHOLD" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SPIKE: CPU usage $cpu% exceeded threshold ${CPU_THRESHOLD}%"
    fi
    
    if [ "$mem_int" -gt "$MEMORY_THRESHOLD" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SPIKE: Memory usage $mem% exceeded threshold ${MEMORY_THRESHOLD}%"
    fi
    
    cpu_sum=$(awk "BEGIN {print $cpu_sum + $cpu}")
    mem_sum=$(awk "BEGIN {print $mem_sum + $mem}")
    check_count=$((check_count + 1))
    
    current_time=$(date +%s)
    elapsed=$((current_time - last_report_time))
    
    if [ "$elapsed" -ge "$REPORT_INTERVAL" ]; then
        avg_cpu=$(awk "BEGIN {printf \"%.2f\", $cpu_sum / $check_count}")
        avg_mem=$(awk "BEGIN {printf \"%.2f\", $mem_sum / $check_count}")
        
        warnings=$(count_log_entries "WARN")
        errors=$(count_log_entries "ERROR")
        
        echo "=========================================="
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] REPORT"
        echo "Average CPU: ${avg_cpu}%"
        echo "Average Memory: ${avg_mem}%"
        echo "Warnings: $warnings"
        echo "Errors: $errors"
        echo "=========================================="
        
        cpu_sum=0
        mem_sum=0
        check_count=0
        last_report_time=$current_time
        update_last_log_line
    fi
    
    sleep $CHECK_INTERVAL
done
