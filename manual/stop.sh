#!/bin/bash

# Function to clean up background processes
cleanup() {
  echo "Stopping all background processes..."
  # Kill all ffmpeg processes started by this script
  pkill ffmpeg
  exit 0
}

# Trap to catch signals and cleanup
trap cleanup SIGINT SIGTERM

# Your existing script logic goes here...

# Wait for all background FFmpeg processes to finish
wait
