

# Function to send email
send_alert() {
    echo "$1" | mail -s "Alert: $2 exceeded threshold" your-email@example.com
}

# CPU Usage: Alert if usage exceeds 90%
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if (( $(echo "$cpu_usage > 90" | bc -l) )); then
    send_alert "CPU usage is critically high: ${cpu_usage}%" "CPU"
fi

# Disk Usage: Alert if usage exceeds 80%
disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ $disk_usage -gt 80 ]; then
    send_alert "Disk usage is critically high: ${disk_usage}%" "Disk"
fi

# Memory Usage: Alert if free memory is less than 500MB
memory_free=$(free -m | grep Mem | awk '{print $4}')
if [ $memory_free -lt 500 ]; then
    send_alert "Memory is running low: ${memory_free}MB free" "Memory"
fi
