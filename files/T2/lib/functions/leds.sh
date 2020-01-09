#!/bin/sh
# Copyright (C) 2013 OpenWrt.org

get_dt_led() {
	local label
	local ledpath
	local basepath="/proc/device-tree"
	local nodepath="$basepath/aliases/led-$1"

	[ -f "$nodepath" ] && ledpath=$(cat "$nodepath")
	[ -n "$ledpath" ] && \
		label=$(cat "$basepath$ledpath/label" 2>/dev/null) || \
		label=$(cat "$basepath$ledpath/chan-name" 2>/dev/null)

	echo "$label"
}

led_set_attr() {
	[ -f "/sys/class/leds/$1/$2" ] && echo "$3" > "/sys/class/leds/$1/$2"
}

led_timer() {
	led_set_attr $1 "trigger" "timer"
	led_set_attr $1 "delay_on" "$2"
	led_set_attr $1 "delay_off" "$3"
}

led_on() {
	led_set_attr $1 "trigger" "none"
	led_set_attr $1 "brightness" 255
}

led_off() {
	led_set_attr $1 "trigger" "none"
	led_set_attr $1 "brightness" 0
}

status_led_set_timer() {
	led_timer $status_led "$1" "$2"
	[ -n "$status_led2" ] && led_timer $status_led2 "$1" "$2"
}

status_led_set_heartbeat() {
	led_set_attr $status_led "trigger" "heartbeat"
}

status_led_on() {
	led_on $status_led
	[ -n "$status_led2" ] && led_on $status_led2
}

status_led_off() {
	led_off $status_led
	[ -n "$status_led2" ] && led_off $status_led2
}

status_led_blink_slow() {
	led_timer $status_led 1000 1000
}

status_led_blink_fast() {
	led_timer $status_led 100 100
	led_timer tel-t2:blue:signal1 100 100
	led_timer tel-t2:blue:signal2 100 100
	led_timer tel-t2:blue:signal3 100 100
}

status_led_blink_preinit() {
	led_timer $status_led 100 100
	led_timer tel-t2:blue:signal1 200 200
	led_timer tel-t2:blue:signal2 200 200
	led_timer tel-t2:blue:signal3 200 200 
}

status_led_blink_failsafe() {
	led_timer $status_led 50 50
	led_timer tel-t2:blue:signal1 50 50
	led_timer tel-t2:blue:signal2 50 50
	led_timer tel-t2:blue:signal3 50 50
}

status_led_blink_preinit_regular() {
	led_timer tel-t2:blue:signal3 300 1600
	led_timer tel-t2:blue:signal2 300 600
	led_timer tel-t2:blue:signal1 300 1600
	led_on tel-t2:blue:wan
	led_on tel-t2:blue:lan
	led_on tel-t2:blue:wlan

}
