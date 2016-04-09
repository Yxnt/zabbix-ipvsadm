#!/bin/bash

SVC_FLG=1
END_FLG=0
IFS=$'\n'

echo '{ "data" : ['
r_line=`sudo /sbin/ipvsadm -ln | wc -l`

for LINE in `sudo /sbin/ipvsadm -Ln` ;do
    for line in `seq $END_FLG $r_line`; do
	TYPE=`echo ${LINE} | awk '{print $1}'`
	IP_INFO=`echo ${LINE} | awk '{print $2}'`
	if [ "${TYPE}" = "TCP" -o "${TYPE}" = "UDP" ] ; then
		CUR_TYPE=${TYPE}
		CUR_IP_INFO=${IP_INFO}
		SVC_FLG=0
	elif [ "${END_FLG}" = "$(($r_line-1))" ];then
		echo -n "{ \"{#VTYPE}\" : \"${CUR_TYPE}\", \"{#VIPINFO}\" : \"${CUR_IP_INFO}\", \"{#RIPINFO}\" : \"${IP_INFO}\" }"
	elif [ "${TYPE}" = "->" -a ${SVC_FLG} = 0 ] ; then
		echo -n "{ \"{#VTYPE}\" : \"${CUR_TYPE}\", \"{#VIPINFO}\" : \"${CUR_IP_INFO}\", \"{#RIPINFO}\" : \"${IP_INFO}\" },"
	fi
	break
    done
    END_FLG=$(($END_FLG+1))
done
echo " ] }"

