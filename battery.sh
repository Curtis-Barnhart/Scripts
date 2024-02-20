#!/bin/bash

battery() {
    upower -i /org/freedesktop/UPower/devices/battery_macsmc_battery
}

