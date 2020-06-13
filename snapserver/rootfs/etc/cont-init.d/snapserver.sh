#!/usr/bin/with-contenv bashio
# ==============================================================================
# Sets up the configuration file for snapserver
# ==============================================================================

mkdir -p /share/snapfifo
mkdir -p /share/snapcast

CONFIG_FILE=/etc/snapserver.conf

if ! bashio::fs.file_exists '/etc/snapserver.conf'; then
    touch /etc/snapserver.conf ||
        bashio::exit.nok "Could not create snapserver.conf file on filesystem"
fi
bashio::log.info "Populating snapserver.conf..."

# Start creation of configuration

echo "[stream]" > "${CONFIG_FILE}"
for stream in $(bashio::config 'stream.streams'); do
    echo "stream = ${stream}" >> "${CONFIG_FILE}"
done
echo "buffer = $(bashio::config 'stream.buffer')" >> "${CONFIG_FILE}"
echo "codec = $(bashio::config 'stream.codec')" >> "${CONFIG_FILE}"
echo "send_to_muted = $(bashio::config 'stream.send_to_muted')" >> "${CONFIG_FILE}"
echo "sampleformat = $(bashio::config 'stream.sampleformat')" >> "${CONFIG_FILE}"

echo "[http]" >> "${CONFIG_FILE}"
echo "enabled = $(bashio::config 'http.enabled')" >> "${CONFIG_FILE}"
echo "doc_root = $(bashio::config 'http.docroot')" >> "${CONFIG_FILE}"

echo "[tcp]" >> "${CONFIG_FILE}"
echo "enabled = $(bashio::config 'tcp.enabled')" >> "${CONFIG_FILE}"

echo "[logging]" >> "${CONFIG_FILE}"
echo "debug = $(bashio::config 'logging.enabled')" >> "${CONFIG_FILE}"

echo "[server]" >> "${CONFIG_FILE}"
echo "threads = $(bashio::config 'server.threads')" >> "${CONFIG_FILE}"

echo "[server]" >> "${CONFIG_FILE}"
echo "datadir = $(bashio::config 'server.datadir')" >> "${CONFIG_FILE}"
