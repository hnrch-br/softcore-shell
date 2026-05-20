#!/usr/bin/env bash
API_KEY="f731508256f91847d83ccf204c8cd79f" # Paste your key here
LAT="-23.5505"  # Replace with your Latitude
LON="-46.6333" # Replace with your Longitude
UNITS="metric" # Use "metric" for Celsius, "imperial" for Fahrenheit
# ---------------------

# Validate configuration
if [ -z "$LAT" ] || [ -z "$LON" ] || [ -z "$UNITS" ] || [ -z "$API_KEY" ]; then
    echo "Config missing"
    exit 1
fi

# Fetch the weather data
RESPONSE=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=${UNITS}")

# Check if curl failed to get a response
if [ -z "$RESPONSE" ]; then
    echo "No connection"
    exit 1
fi

# 1. Get the Temperature
# We use jq's built-in 'round' function to avoid ugly decimals (e.g., 71.6°F becomes 72°F)
TEMP=$(echo "$RESPONSE" | jq '.main.temp | round')

# 2. Get the Description (for the tooltip)
DESC=$(echo "$RESPONSE" | jq -r '.weather[0].description')

# 3. Get the Icon Code and map it to an emoji
ICON_CODE=$(echo "$RESPONSE" | jq -r '.weather[0].icon')

case $ICON_CODE in
    "01d") ICON="light_mode";;  # Clear sky day
    "01n") ICON="dark_mode";;  # Clear sky night
    "02d") ICON="partly_cloudy_day";;  # Few clouds day
    "02n") ICON="partly_cloudy_night";;  # Few clouds night
    "03d"|"03n") ICON="cloud";; # Scattered clouds
    "04d"|"04n") ICON="cloud";; # Broken clouds
    "09d"|"09n") ICON="rainy_light";; # Shower rain
    "10d") ICON="rainylight_mode";; # Rain day
    "10n") ICON="rainydark_mode";; # Rain night
    "11d"|"11n") ICON="thunderstorm";; # Thunderstorm
    "13d"|"13n") ICON="snowflake";; # Snow
    "50d"|"50n") ICON="mist";; # Mist
    *) ICON="?";;      # Default
esac

# Determine unit label
if [ "$UNITS" = "metric" ]; then
    LABEL="°C"
else
    LABEL="°F"
fi

# Final JSON output for Waybar
echo "{\"text\": \"${TEMP}${LABEL}\",\"icon\": \"${ICON}\", \"tooltip\": \"${DESC}\"}"
