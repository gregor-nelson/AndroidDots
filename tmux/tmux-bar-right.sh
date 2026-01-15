#!/data/data/com.termux/files/usr/bin/bash

# tmux status bar right - OneDark theme
# Outputs tmux-formatted status line for right side

# Colors (OneDark)
black="#1e222a"
green="#7eca9c"
white="#abb2bf"
grey="#282c34"
blue="#7aa2f7"
red="#d47d85"
darkblue="#668ee3"
yellow="#e5c07b"
pink="#c678dd"

# Icons
mem_icon="󰍛"
wifi_icon_excellent="󰤨"
wifi_icon_good="󰤥"
wifi_icon_fair="󰤢"
wifi_icon_weak="󰤟"
wifi_icon_off="󰤮"
battery_icon_charging="󰂄"
battery_icon_low="󰁺"
battery_icon_medium="󰁼"
battery_icon_full="󰁹"
battery_icon_unknown="󰂑"
clock_icon="󱑆"

# Helper: create a pill with label and value
# Usage: pill <label_bg> <label_fg> <label> <value>
pill() {
    local label_bg="$1" label_fg="$2" label="$3" value="$4"
    printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] %s " "$label_fg" "$label_bg" "$label" "$white" "$grey" "$value"
}

# CPU temperature and load
cpu() {
    local max_temp=0 temp_raw load_avg
    for zone in /sys/class/thermal/thermal_zone*/; do
        type=$(cat "${zone}type" 2>/dev/null)
        if [[ "$type" == cpu* ]]; then
            temp_raw=$(cat "${zone}temp" 2>/dev/null)
            if [ -n "$temp_raw" ] && [ "$temp_raw" -gt "$max_temp" ]; then
                max_temp="$temp_raw"
            fi
        fi
    done
    load_avg=$(uptime | awk -F'load average: ' '{print $2}' | cut -d',' -f1)
    if [ "$max_temp" -gt 0 ]; then
        printf "#[fg=%s,bg=%s] CPU #[fg=%s,bg=%s] %s°C %s " "$black" "$green" "$white" "$grey" "$((max_temp / 1000))" "$load_avg"
    else
        printf "#[fg=%s,bg=%s] CPU #[fg=%s,bg=%s] -- %s " "$black" "$green" "$white" "$grey" "$load_avg"
    fi
}

# Memory usage
mem() {
    local used total
    used=$(free -h | awk '/^Mem/ { print $3 }' | sed 's/i//g')
    total=$(free -h | awk '/^Mem/ { print $2 }' | sed 's/i//g')
    printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] %s/%s " "$pink" "$grey" "$mem_icon" "$white" "$grey" "$used" "$total"
}

# WiFi signal strength
wifi() {
    local rssi icon
    rssi=$(termux-wifi-connectioninfo 2>/dev/null | grep '"rssi"' | grep -o '\-*[0-9]*')

    if [ -n "$rssi" ]; then
        # Signal strength icons based on rssi
        if [ "$rssi" -gt -50 ]; then
            icon="$wifi_icon_excellent"
        elif [ "$rssi" -gt -60 ]; then
            icon="$wifi_icon_good"
        elif [ "$rssi" -gt -70 ]; then
            icon="$wifi_icon_fair"
        else
            icon="$wifi_icon_weak"
        fi
        printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] %sdB " "$darkblue" "$grey" "$icon" "$white" "$grey" "$rssi"
    else
        printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] N/A " "$red" "$grey" "$wifi_icon_off" "$white" "$grey"
    fi
}

# Battery status
battery() {
    local info pct plugged icon icon_color
    info=$(termux-battery-status 2>/dev/null)

    if [ -n "$info" ]; then
        pct=$(echo "$info" | grep '"percentage"' | grep -o '[0-9]*')
        plugged=$(echo "$info" | grep '"plugged"' | grep -o '"[A-Z]*"' | tr -d '"')

        # Icon and color based on charge level and status
        if [ "$plugged" != "UNPLUGGED" ]; then
            icon="$battery_icon_charging"
            icon_color="$green"
        elif [ "$pct" -le 20 ]; then
            icon="$battery_icon_low"
            icon_color="$red"
        elif [ "$pct" -le 40 ]; then
            icon="$battery_icon_medium"
            icon_color="$yellow"
        else
            icon="$battery_icon_full"
            icon_color="$green"
        fi

        printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] %s%% " "$icon_color" "$grey" "$icon" "$white" "$grey" "$pct"
    else
        printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] -- " "$red" "$grey" "$battery_icon_unknown" "$white" "$grey"
    fi
}

# Clock
clock() {
    local time_str
    time_str=$(date '+%a %d %b %I:%M %p')
    printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] %s " "$black" "$darkblue" "$clock_icon" "$black" "$blue" "$time_str"
}

# Build the status line
main() {
    printf "%s%s%s%s%s#[default]" "$(cpu)" "$(mem)" "$(wifi)" "$(battery)" "$(clock)"
}

main
