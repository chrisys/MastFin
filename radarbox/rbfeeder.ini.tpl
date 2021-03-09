[client]
network_mode=true
key=${RADARBOX_KEY}
lat=${LAT}
lon=${LON}
alt=${ALT}

[network]
mode=beast
external_host=${RECEIVER_HOST}
external_port=${RECEIVER_PORT}

[mlat]
autostart_mlat=true

[dump978]
dump978_enabled=${UAT_RB_ENABLED}
dump978_port=30979