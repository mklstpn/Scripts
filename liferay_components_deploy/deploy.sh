#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'


# Catalina log file
catalina="/path/to/liferay/tomcat/logs/catalina.out"

# Date
deploy_date(){
	      date +"%d/%m/%y %H:%M:%S"
}

# Spinner animation
spinner(){
carousel=("/" "-" "\\" "|" )
for item in ${carousel[*]}
do
    echo -en "\r$item"
    sleep .1
    echo -en "\r"
done
}

# Delay for prevent liferay log freeze
delay(){
        numbers=(5 4 3 2 1)
        echo -n "Delay "
        for item in ${numbers[*]}
        do
            echo -en "$item.. "
            sleep 2
        done
        echo -en "\r                                                   "
}

# Checking the amount of files in dir
if [ $(ls ./new_release | wc -l) -ne 1 ];
then
    echo -e "${CYAN}[$(deploy_date)]${RED} Only 1 file is acceptable!${NOCOLOR}\n"
    exit 1
else
    echo -e "${CYAN}[$(deploy_date)]${GREEN} Cathed 1 file${NOCOLOR}\n"
fi

# Getting a number of version
version=$(ls ./new_release | sed -e 's/YOTARU_//' -e 's/.zip//')

# Writing to log
exec &> >(tee -a ./releases/YOTARU_${version}_deploy.log)
echo -e "${CYAN}[$(deploy_date)] Deploying YOTARU_${version}${NOCOLOR}\n"

# Unzip archive
unzip ./new_release/YOTARU_${version}.zip -d ./releases/YOTARU_${version} &> /dev/null
echo -e "${CYAN}[$(deploy_date)]${GREEN} Archive unzipped to ./releases/YOTARU_${version}${NOCOLOR}\n"

# Moving all portlets to the upper directory for more beautifully
mv ./releases/YOTARU_${version}/Release_*/* ./releases/YOTARU_${version}/ || mv ./releases/YOTARU_${version}/HotFix_*/* ./releases/YOTARU_${version}/
cd ./releases/YOTARU_${version}
rm -rf Release*
cd - &> /dev/null

# Change the owner of all portlets
chown liferay:liferay ./releases/YOTARU_${version}/*

# Getting the list of portlets
portlets=$(ls -lA ./releases/YOTARU_${version} | grep -v "total" | grep ".war" | awk {'print $NF'} | sed 's/-[0-9].*.war//g')
echo -e "${CYAN}[$(deploy_date)] List of portlets that will be installed:\n${RED}${portlets}${NOCOLOR}"

# Deploy each portlet from the list
mkdir ./releases/YOTARU_${version}/backup
for portlet in ${portlets[*]}
do
    # Backup previous version of the portlet
    mv /path/to/liferay/tomcat/portlets/${portlet}* ./releases/YOTARU_${version}/backup
    echo -e "\n${CYAN}[$(deploy_date)] Backup for: ${portlet}${NOCOLOR}"
    count=0
    while ! tail -n 100 $catalina | grep "${portlet}" | grep --color=always " were unregistered\| was unregistered"
    do
        count=$((count + 1))
        spinner
	if [ $count -ge 150 ] && [[ $(tail -n 100 $catalina | grep "INFO: Undeploying context [/${portlet}") ]] && ! [[ $(tail -n 100 $catalina | grep " were unregistered\| was unregistered") ]]
        then
	    echo -e "${CYAN}[$(deploy_date)]${YELLOW} Warning! Got an unwanted log message, but still continue.${NOCOLOR}"
            break
	fi
    done
    echo -e "${CYAN}[$(deploy_date)]${GREEN} Portlet ${portlet} successfully undeployed!${NOCOLOR}"
    delay
    
    # Copy the new portlet to deploy dir
    cp -p ./releases/YOTARU_${version}/${portlet}* /path/to/liferay/deploy
    echo -e "\r${CYAN}[$(deploy_date)] Deploy for: ${portlet}${NOCOLOR}"
    count=0
    while ! tail -n 100 $catalina | grep "${portlet}" | grep --color=always " are available for use\| is available for use"
    do
	count=$((count + 1))
        spinner
	if [ $count -ge 150 ] && [[ $(tail -n 100 $catalina | grep "${portlet}" | grep "Deployment will start in a few seconds") ]] && ! [[ $(tail -n 100 $catalina | grep " are available for use\| is available for use") ]]
	then
	    cp -p ./releases/YOTARU_${version}/${portlet}* /path/to/liferay/deploy
	    count=0
	    echo -e "${CYAN}[$(deploy_date)]${YELLOW} Warning! Seems the log is freeze, ${portlet} pushed again.${NOCOLOR}"
	fi
    done
    echo -e "${CYAN}[$(deploy_date)]${GREEN} Portlet ${portlet} successfully deployed!${NOCOLOR}"
    delay
done

echo -e "\r${CYAN}[$(deploy_date)]${GREEN} All portlets succesfully deployed!${NOCOLOR}\n"
exit 0

