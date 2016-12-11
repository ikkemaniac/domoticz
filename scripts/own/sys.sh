#!/bin/bash
# settings
 DOMO_IP="localhost"		# Domoticz IP Address
 DOMO_PORT="8080"		# Domoticz Port
 LAN_IFACE="eth0"		# LAN inerface to get traffic stats from
 LAN_RX_IDX="15"		# LAN received bytes
 LAN_TX_IDX="16"		# LAN transmitted bytes
 DOMO_MEMC_IDX="21"		# domo mem usage in a custom counter (kb - line graph)

### CPU Load in % ###
#CPULoad=`top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }' `
#CPULoadPer=`top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f", prefix, 100 - v }' `
#echo "load (%): $CPULoadPer"
# post data
#curl -s --max-time 20 -i -H "Accept: application/json" -s "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$CPU_LOAD_PER_IDX&nvalue=0&svalue=$CPULoadPer" > /dev/null

### CPU Load in 'double' ###
#CPULoad=`cat /proc/loadavg | awk '{ print $2}'`
#echo "load (double): $CPULoad"
# post data
#curl -s --max-time 20 -i -H "Accept: application/json" -s "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$CPU_LOAD_IDX&nvalue=0&svalue=$CPULoad" > /dev/null

### LAN Traffic in bytes ###
LANTraffic=`cat /proc/net/dev|grep $LAN_IFACE| awk  '{print $2+0" "$10+0}';`
LANTrafficRX=`echo $LANTraffic | awk '{ print $1 }'`
LANTrafficTX=`echo $LANTraffic | awk '{ print $2 }'`
echo "LAN RX (b): $LANTrafficRX"
echo "LAN TX (b): $LANTrafficTX"
# post data
curl -s --max-time 20 -i -H "Accept: application/json" -s "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$LAN_RX_IDX&nvalue=0&svalue=$LANTrafficRX" > /dev/null
# post data
curl -s --max-time 20 -i -H "Accept: application/json" -s "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$LAN_TX_IDX&nvalue=0&svalue=$LANTrafficTX" > /dev/null

### Domoticz memory usage ###
DOMOMemUsagekB=`cat /proc/$(pgrep domoticz)/status |grep VmRSS |awk '{ print $2 }'`
echo "DOMO mem usage (kB): $DOMOMemUsagekB"
# post data
curl -s --max-time 20 -i -H "Accept: application/json" -s "http://$DOMO_IP:$DOMO_PORT/json.htm?type=command&param=udevice&idx=$DOMO_MEMC_IDX&nvalue=0&svalue=$DOMOMemUsagekB" > /dev/null
