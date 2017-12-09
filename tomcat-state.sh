#!/bin/sh  
$grep_result  
grep_result=`ps -ef |grep tomcat|grep "/usr/local/Cellar/tomcat/8.5.23"|grep -v "grep"`  

if [ "$grep_result" = "" ]
then  
    echo "tomcat not run"  
else  
    echo "tomcat is running..."    
fi  
