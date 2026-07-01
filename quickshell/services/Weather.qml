pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property string city: ""

    property real lat: 0
    property real lon: 0

    property int humidity: 0
    property int tempCur: 0
    property int codeCur: 0

    property var hourly: []
    property var daily: []

    property bool located: false
    property bool ready: false
    property bool isDay: true

    function fetchWeather() {
        if (!located || weatherProc.running)
            return;
        weatherProc.running = true
    }

    function glyph(codeCur, isDay) {
        if (codeCur === 0)
            return isDay ? "sunny" : "nightlight";
        if (codeCur <= 2)
            return isDay ? "partly_cloudy_day" : "partly_cloudy_night";
        if (codeCur === 3)
            return "cloud";
        if (codeCur === 45 || codeCur === 48)
            return "foggy";
        if (codeCur >= 95)
            return "thunderstorm";
        if ((codeCur >= 71 && codeCur <= 77) || codeCur === 85 || codeCur === 86)
            return "snowflake";
        if ((codeCur >= 51 && codeCur <= 67) || (codeCur >= 80 && codeCur <= 82))
            return "rainy";
        return "cloud";
    }

    Process {
        id: geoProc
        running: true
        command: ["curl", "-s", "--max-time", "8", "http://ip-api.com/json?fields=lat,lon,city"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let a = JSON.parse(this.text)
                    if (typeof a.lat === "number" && typeof a.lon === "number") {
                        root.city = a.city || "";
                        root.lat = a.lat;
                        root.lon = a.lon;
                        root.located = true;
                        root.fetchWeather();
                    }
                } catch (e) {
                    console.warn("geoProc: failed to parse location", e)
                }
            }
        }
    }

    Process {
        id: weatherProc
        command: ["curl", "-s", "--max-time", "10",
            "https://api.open-meteo.com/v1/forecast?latitude=" + root.lat
            + "&longitude=" + root.lon
            + "&current=temperature_2m,weather_code,is_day,relative_humidity_2m"
            + "&hourly=temperature_2m,weather_code&forecast_hours=24"
            + "&daily=weather_code,temperature_2m_max,relative_humidity_2m_mean&forecast_days=5&timezone=auto"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var d = JSON.parse(this.text);
                    root.tempCur = Math.round(d.current.temperature_2m);
                    root.humidity = d.current.relative_humidity_2m;
                    root.codeCur = d.current.weather_code;
                    root.isDay = d.current.is_day === 1;

                    var h = [];
                    for (var i = 0; i < d.hourly.time.length; i++) {
                        h.push({
                            time: d.hourly.time[i],
                            temp: d.hourly.temperature_2m[i],
                            code: d.hourly.weather_code[i]
                        });
                    };
                    root.hourly = h;
                    var dly = [];
                    for (var j = 0; j < d.daily.time.length; j++) {
                        dly.push({
                            date: d.daily.time[j],
                            code: d.daily.weather_code[j],
                            tempMax: d.daily.temperature_2m_max[j],
                            humidity: d.daily.relative_humidity_2m_mean[j]
                        });
                    }
                    root.daily = dly

                    root.ready = true

                } catch(e) {
                    console.warn("weatherProc: failed to parse forecast", e)
                }
            }
        }
    }

    Timer {
        interval: 1200000
        running: true
        repeat: true
        onTriggered: root.fetchWeather()
    }
}
