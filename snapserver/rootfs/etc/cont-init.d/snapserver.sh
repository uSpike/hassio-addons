#!/usr/bin/with-contenv bashio
# ==============================================================================
# Sets up the configuration file for snapserver
# ==============================================================================

mkdir -p /share/snapfifo
mkdir -p /share/snapcast

CONFIG_FILE=/etc/snapserver.conf

config_or_default() {
    local config="$1"
    local default="$2"
    if bashio::config.has_value "$config"; then
        echo $(bashio::config "$config");
    else
        echo $default
    fi
}

CONF_BUFFER=$(config_or_default 'stream.buffer' 1000)
CONF_CODEC=$(config_or_default 'stream.codec' flac)
CONF_SEND_TO_MUTED=$(config_or_default 'stream.send_to_muted' 'false')
CONF_SAMPLEFORMAT=$(config_or_default 'stream.sampleformat' '48000:16:2')

if ! bashio::fs.file_exists '/etc/snapserver.conf'; then
    touch /etc/snapserver.conf ||
        bashio::exit.nok "Could not create snapserver.conf file on filesystem"
fi

bashio::log.info "Populating snapserver.conf..."

echo "[stream]" > "${CONFIG_FILE}"
for stream in $(config_or_default 'stream.streams' ''); do
    echo "stream = ${stream}" >> "${CONFIG_FILE}"
done
echo "buffer = ${CONF_BUFFER}" >> "${CONFIG_FILE}"
echo "codec = ${CONF_CODEC}" >> "${CONFIG_FILE}"
echo "send_to_muted = ${CONF_SEND_TO_MUTED}" >> "${CONFIG_FILE}"
echo "sampleformat = ${CONF_SAMPLEFORMAT}" >> "${CONFIG_FILE}"

echo "[http]" >> "${CONFIG_FILE}"
echo "enabled = true" >> "${CONFIG_FILE}"
echo "port = 8099" >> "${CONFIG_FILE}"
echo "doc_root = /usr/src/snapweb/page" >> "${CONFIG_FILE}"

echo "[tcp]" >> "${CONFIG_FILE}"
echo "enabled = true" >> "${CONFIG_FILE}"

echo "[logging]" >> "${CONFIG_FILE}"
echo "debug = false" >> "${CONFIG_FILE}"

echo "[server]" >> "${CONFIG_FILE}"
echo "threads = -1" >> "${CONFIG_FILE}"
echo "datadir = /share/snapcast/" >> "${CONFIG_FILE}"
