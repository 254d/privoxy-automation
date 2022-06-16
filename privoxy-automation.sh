#!/bin/bash
cd /etc/privoxy

sudo wget http://andrwe.org/_export/code/scripting/bash/privoxy-blocklist -O privoxy-blocklist.sh
sudo sed -i -e 's/http:\/\/adblockplus.mozdev.org\/easylist\/easylist.txt/https:\/\/easylist.to\/easylist\/easylist.txt/' privoxy-blocklist.sh
sudo chmod 700 privoxy-blocklist.sh
sudo bash privoxy-blocklist.sh

sudo wget https://raw.githubusercontent.com/skroll/privoxy-adblock/master/privoxy-adblock.sh -O privoxy-adblock.sh
sudo chmod 700 privoxy-adblock.sh
sudo sh -c "bash privoxy-adblock.sh -p /etc/privoxy -u https://raw.githubusercontent.com/k2jp/abp-japanese-filters/master/abpjf.txt"
sudo sh -c "bash privoxy-adblock.sh -p /etc/privoxy -u https://raw.githubusercontent.com/tofukko/filter/master/Adblock_Plus_list.txt"
sudo sh -c "bash privoxy-adblock.sh -p /etc/privoxy -u https://qme.mydns.jp/data/AdblockV2.txt"

YYYYMM=`date "+%Y%m"`
sudo sh -c "bash privoxy-adblock.sh -p /etc/privoxy -u https://280blocker.net/files/280blocker_adblock_${YYYYMM}.txt"

sudo sed -i -r -e "/filterfile 280blocker_adblock_.*.script.filter$/d" -e "/actionsfile 280blocker_adblock_.*.script.action$/d" config

ACTIONS_INSERT_LINE=`sed -n '/actionsfile user.action/=' config`
FILTER_INSERT_LINE=`sed -n '/filterfile user.filter/=' config`
sudo sed -i -e "${ACTIONS_INSERT_LINE}aactionsfile 280blocker_adblock_${YYYYMM}.script.action" -e "${FILTER_INSERT_LINE}afilterfile 280blocker_adblock_${YYYYMM}.script.filter" config

sudo systemctl restart privoxy.service

