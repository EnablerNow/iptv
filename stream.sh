#!/bin/bash

SERVICE_NAME="iptv"
MAIN_DIR="/home/test/Documents/code/iptv"
M3U_FILE_OR_URL="israel.m3u"  # Place your M3U file path or remote URL here
OUTPUT_DIR="/var/www/hls/live"
PORT="80"
OUTPUT_M3U="channels.m3u"  # Output M3U file
USERNAME=""
PASSWORD=""

# Ensure the script is only run once
lockfile="/var/lock/${SERVICE_NAME}.lock"
exec 200>"$lockfile"
flock -n 200 || { echo "Service already running."; exit 1; }

# Get host IP address, retry if network is not ready
get_host_ip() {
  local max_retries=10
  local retry_count=0
  local sleep_interval=5

  while true; do
    HOST_IP=$(hostname -I | awk '{print $1}')
    if [ -n "$HOST_IP" ]; then
      break
    fi
    ((retry_count++))
    if [ "$retry_count" -ge "$max_retries" ]; then
      echo "Network not ready, failed to obtain IP after $max_retries attempts."
      exit 1
    fi
    echo "Waiting for network... Attempt $retry_count/$max_retries"
    sleep "$sleep_interval"
  done
}

get_host_ip

cd "$MAIN_DIR" || { echo "Failed to change directory to $MAIN_DIR"; exit 1; }

# Ensure the output directory exists for FFmpeg
mkdir -p "$OUTPUT_DIR"

# Clear or create the channels URL file and add M3U header
echo "#EXTM3U" > "$OUTPUT_M3U"

process_stream() {
  local URL="$1"
  local STREAM_NAME="$2"
  local TVG_ID="$3"
  local TVG_LOGO="$4"
  local GROUP_TITLE="$5"
  local SAFE_NAME=$(echo "$STREAM_NAME" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_]//g')
  local OUTPUT_PLAYLIST="${OUTPUT_DIR}/${SAFE_NAME}.m3u8"

  echo "Starting FFmpeg streaming for $STREAM_NAME"
  
  while true; do
    ffmpeg -re -i "$URL" \
           -c copy \
           -f hls \
           -hls_time 10 \
           -hls_list_size 5 \
           -hls_flags delete_segments \
           -http_persistent 1 \
           -reconnect 1 \
           -reconnect_streamed 1 \
           -reconnect_delay_max 5 \
           -rw_timeout 5000000 \
           -user_agent "FFmpeg" \
           "$OUTPUT_PLAYLIST"

    if [ $? -eq 0 ]; then
      echo "Stream stopped, attempting to restart: $STREAM_NAME"
    else
      echo "Stream failed: $STREAM_NAME"
      sleep 2
    fi
  done &

  echo -e "#EXTINF:-1 tvg-id=\"$TVG_ID\" tvg-logo=\"$TVG_LOGO\" group-title=\"$GROUP_TITLE\",$STREAM_NAME\nhttp://$HOST_IP:$PORT/${SAFE_NAME}.m3u8" >> "$OUTPUT_M3U"
}

parse_extinf() {
  local line="$1"
  local extinf_regex='tvg-id="([^"]*)" tvg-logo="([^"]*)" group-title="([^"]*)",(.*)'
  if [[ $line =~ $extinf_regex ]]; then
    echo "${BASH_REMATCH[1]}|${BASH_REMATCH[2]}|${BASH_REMATCH[3]}|${BASH_REMATCH[4]}"
  else
    echo "|||"
  fi
}

stop_streams() {
  echo "Stopping all streams..."
  kill $(jobs -p)
}

trap stop_streams EXIT

if [[ $M3U_FILE_OR_URL == http* ]]; then
  curl -s "$M3U_FILE_OR_URL" | while IFS= read -r line
  do
    if [[ $line == \#EXTINF* ]]; then
      IFS='|' read -r TVG_ID TVG_LOGO GROUP_TITLE STREAM_NAME <<< "$(parse_extinf "$line")"
    elif [[ $line != \#* && ! -z $line ]]; then
      process_stream "$line" "$STREAM_NAME" "$TVG_ID" "$TVG_LOGO" "$GROUP_TITLE"
    fi
  done
else
  while IFS= read -r line
  do
    if [[ $line == \#EXTINF* ]]; then
      IFS='|' read -r TVG_ID TVG_LOGO GROUP_TITLE STREAM_NAME <<< "$(parse_extinf "$line")"
    elif [[ $line != \#* && ! -z $line ]]; then
      process_stream "$line" "$STREAM_NAME" "$TVG_ID" "$TVG_LOGO" "$GROUP_TITLE"
    fi
  done < "$M3U_FILE_OR_URL"
fi

wait

echo "Stream URLs have been saved to $OUTPUT_M3U"
rsync -av "$OUTPUT_M3U" "$OUTPUT_DIR"
