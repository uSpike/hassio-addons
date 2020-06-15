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

if ! bashio::fs.file_exists '/etc/snapserver.conf'; then
    touch /etc/snapserver.conf ||
        bashio::exit.nok "Could not create snapserver.conf file on filesystem"
fi
bashio::log.info "Populating snapserver.conf..."

# Start creation of configuration

echo "[stream]" > "${CONFIG_FILE}"
for stream in $(config_or_default 'stream.streams' ''); do
    echo "stream = ${stream}" >> "${CONFIG_FILE}"
done
echo "buffer = $(config_or_default 'stream.buffer' 1000)" >> "${CONFIG_FILE}"
echo "codec = $(config_or_default 'stream.codec' flac)" >> "${CONFIG_FILE}"
echo "send_to_muted = $(config_or_default 'stream.send_to_muted' 'false')" >> "${CONFIG_FILE}"
echo "sampleformat = $(config_or_default 'stream.sampleformat' '48000:16:2')" >> "${CONFIG_FILE}"

echo "[http]" >> "${CONFIG_FILE}"
echo "enabled = $(config_or_default 'http.enabled' 'false')" >> "${CONFIG_FILE}"
echo "doc_root = $(config_or_default 'http.docroot' '')" >> "${CONFIG_FILE}"

echo "[tcp]" >> "${CONFIG_FILE}"
echo "enabled = $(config_or_default 'tcp.enabled' 'true')" >> "${CONFIG_FILE}"

echo "[logging]" >> "${CONFIG_FILE}"
echo "debug = $(config_or_default 'logging.enabled' 'false')" >> "${CONFIG_FILE}"

echo "[server]" >> "${CONFIG_FILE}"
echo "threads = $(config_or_default 'server.threads' '-1')" >> "${CONFIG_FILE}"
echo "datadir = /share/snapcast/" >> "${CONFIG_FILE}"
