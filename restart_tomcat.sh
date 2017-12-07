######################################################################################################
#!/bin/bash
echo "RESTARTING TOMCAT SERVICES"
sleep 1
######################################################################################################
echo "STOP SERVICE 01"
{
/opt/tomcat7/bin/catalina.sh stop
} &> /dev/null
sleep 3
{
kill $(ps aux | grep 'java' | grep 'tomcat7/' | awk '{print $2}')
} &> /dev/null
echo "CLEARING CACHE"
{
rm /var/run/tomcat7.pid
rm -rf /opt/tomcat7/temp/*
rm -rf /opt/tomcat7/work/*
} &> /dev/null
echo "START SERVICE 01"
{
/opt/tomcat7/bin/catalina.sh start
} &> /dev/null
sleep 3
while true
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/)
  if [ $STATUS -eq 200 ]; then
    echo "SERVICE 01 STATUS 200, DONE"
    break
  else
    echo "SERVICE 01 STATUS $STATUS WAITING FOR 5 SECONDS"
  fi
  sleep 5
done
######################################################################################################
######################################################################################################
echo "STOP SERVICE 02"
{
/opt/tomcat7_2/bin/catalina.sh stop
} &> /dev/null
sleep 3
{
kill $(ps aux | grep 'java' | grep 'tomcat7_2/' | awk '{print $2}')
} &> /dev/null
echo "CLEARING CACHE"
{
rm /var/run/tomcat7_2.pid
rm -rf /opt/tomcat7_2/temp/*
rm -rf /opt/tomcat7_2/work/*
} &> /dev/null
echo "START SERVICE 02"
{
/opt/tomcat7_2/bin/catalina.sh start
} &> /dev/null
sleep 3
while true
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8081/)
  if [ $STATUS -eq 200 ]; then
    echo "SERVICE 02 STATUS 200, DONE"
    break
  else
    echo "SERVICE 02 STATUS $STATUS WAITING FOR 5 SECONDS"
  fi
  sleep 5
done
######################################################################################################
######################################################################################################
echo "STOP SERVICE 03"
{
/opt/tomcat7_3/bin/catalina.sh stop
} &> /dev/null
sleep 3
{
kill $(ps aux | grep 'java' | grep 'tomcat7_3/' | awk '{print $2}')
} &> /dev/null
echo "CLEARING CACHE"
{
rm /var/run/tomcat7_3.pid
rm -rf /opt/tomcat7_3/temp/*
rm -rf /opt/tomcat7_3/work/*
} &> /dev/null
echo "START SERVICE 03"
{
/opt/tomcat7_3/bin/catalina.sh start
} &> /dev/null
sleep 3
while true
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8082/)
  if [ $STATUS -eq 200 ]; then
    echo "SERVICE 03 STATUS 200, DONE"
    break
  else
    echo "SERVICE 03 STATUS $STATUS WAITING FOR 5 SECONDS"
  fi
  sleep 5
done
######################################################################################################
######################################################################################################
echo "STOP SERVICE 04"
{
/opt/tomcat7_4/bin/catalina.sh stop
} &> /dev/null
sleep 3
{
kill $(ps aux | grep 'java' | grep 'tomcat7_4/' | awk '{print $2}')
} &> /dev/null
echo "CLEARING CACHE"
{
rm /var/run/tomcat7_4.pid
rm -rf /opt/tomcat7_4/temp/*
rm -rf /opt/tomcat7_4/work/*
} &> /dev/null
echo "START SERVICE 04"
{
/opt/tomcat7_4/bin/catalina.sh start
} &> /dev/null
sleep 3
while true
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8083/)
  if [ $STATUS -eq 200 ]; then
    echo "SERVICE 04 STATUS 200, DONE"
    break
  else
    echo "SERVICE 04 STATUS $STATUS WAITING FOR 5 SECONDS"
  fi
  sleep 5
done
######################################################################################################
echo "CLEARING SYSTEM CACHES"
free && sync && echo 3 > /proc/sys/vm/drop_caches && free
exit
