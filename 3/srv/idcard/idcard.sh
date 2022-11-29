#!/bin/bash


echo "Machine name : $(hostnamectl hostname)"
echo "OS $(cat /etc/redhat-release) and kernel version is $(uname -s -r)"
echo "IP : $(ip -4 addr | grep inet | tr -s ' ' | cut -d' ' -f3 | cut -d$'\n' -f2)"
echo "RAM : $(free -h --giga | grep Mem | tr -s ' '  | cut -d' ' -f4) memory available on $(free -h --giga | grep Mem | tr -s ' '  | cut -d' ' -f2) total memory"
echo "Disk : $(df -h | grep ' /$' | tr -s ' ' | cut -d' ' -f4) space left"
echo "Top 5 processs by RAM usage :"
a="$(ps -o command= ax --sort=-%mem | head -n5 | tr -s ' ')"
while read guillaume_line
do
	echo " - ${guillaume_line}"
done <<< "${a}"

#Listening ports
 
echo "Listening ports :"

line="$(sudo ss -ln4Hp | tr -s ' ' | cut -d' ' -f1,5,7)"
while read line
do
        tcpudp="$(tr -s ' ' <<< $line | cut -d' ' -f1)"
        ports="$(tr -s ' ' <<< $line | cut -d' ' -f2 | cut -d ':' -f2)"
        process="$(tr -s ' ' <<< $line | cut -d' ' -f3 | cut -d'"' -f2)"
        echo " - ${ports} ${tcpudp} : ${process}"
done <<< "${line}"

# Cat picture
_cat_filename='cat_pic'
curl https://cataas.com/cat -o "${_cat_filename}" 2> /dev/null
_file_command_output="$(file cat_pic)"

if [[ "${_file_command_output}" == *JPEG* ]]
then
  _cat_file_extension='.jpeg'
elif [[ "${_file_command_output}" == *PNG* ]]
then
  _cat_file_extension='.png'
elif [[ "${_file_command_output}" == *GIF* ]]
then
  _cat_file_extension='.gif'
else
  echo "Don't know this format :( Exiting."
  exit 1
fi
_cat_new_filename="${_cat_filename}${_cat_file_extension}"
mv "${_cat_filename}" "${_cat_new_filename}"
echo "Here is your random cat : ${_cat_new_filename}"
