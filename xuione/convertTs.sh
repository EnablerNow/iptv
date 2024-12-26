input=unavailable.png
output=unavailable.ts

ffmpeg -loop 1 -i $input -c:v libx264 -t 10 -pix_fmt yuv420p -f mpegts $output
