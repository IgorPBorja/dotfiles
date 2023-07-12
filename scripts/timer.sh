#https://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
# stop it with Ctrl-C

start=$(date +%s)
while true; do
    time="$(($(date +%s) - $start))"
    printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
done
