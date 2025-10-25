#!/bin/sh

# Working directory
WORK_DIR="work"
mkdir -p "$WORK_DIR"

# Temporary merged file
MERGED_FILE="$WORK_DIR/merged.txt"

# Output file for pfBlockerNG
FINAL_FILE="pfbip-list.txt"

# Define URLs and names directly in the script
LIST=$(cat <<'EOF'
https://feodotracker.abuse.ch/downloads/ipblocklist_recommended.txt Abuse_Feodo_C2
https://cinsarmy.com/list/ci-badguys.txt CINS_army
https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt ET_Block
https://rules.emergingthreats.net/blockrules/compromised-ips.txt ET_Comp
https://isc.sans.edu/block.txt ISC_Block
https://www.spamhaus.org/drop/drop_v4.json Spamhaus_Drop
https://lists.blocklist.de/lists/all.txt BlockListDE_All
https://botscout.com/last_caught_cache.txt BotScout
http://danger.rulez.sk/projects/bruteforceblocker/blist.php DangerRulez
https://blocklist.greensnow.co/greensnow.txt GreenSnow
https://www.stopforumspam.com/downloads/toxic_ip_cidr.txt SFS_Toxic
https://www.binarydefense.com/banlist.txt BDS_Ban
https://www.botvrij.eu/data/ioclist.ip-dst.raw Botvrij_IP
https://cybercrime-tracker.net/fuckerz.php CCT_IP
https://www.darklist.de/raw.php Darklist
https://www.projecthoneypot.org/list_of_ips.php?t=b HoneyPot_Bad
https://www.projecthoneypot.org/list_of_ips.php?t=p HoneyPot_Com
https://www.projecthoneypot.org/list_of_ips.php?t=d HoneyPot_Dict
https://www.projecthoneypot.org/list_of_ips.php?t=h HoneyPot_Harv
https://www.projecthoneypot.org/list_of_ips.php HoneyPot_IPs
https://www.projecthoneypot.org/list_of_ips.php?t=w HoneyPot_Mal
https://www.projecthoneypot.org/list_of_ips.php?t=r HoneyPot_Rule
https://www.projecthoneypot.org/list_of_ips.php?t=se HoneyPot_Search
https://www.projecthoneypot.org/list_of_ips.php?t=s HoneyPot_Spam
https://isc.sans.edu/api/threatlist/miner ISC_Miner
https://www.myip.ms/files/blacklist/csf/latest_blacklist.txt Myip_BL
https://gist.githubusercontent.com/BBcan177/bf29d47ea04391cb3eb0/raw MS_1
https://raw.githubusercontent.com/dibdot/DoH-IP-blocklists/master/doh-ipv4.txt Dibdot_DoH_IP
https://raw.githubusercontent.com/Sekhan/TheGreatWall/master/TheGreatWall_ipv4 TheGreatWall_DoH_IP
https://isc.sans.edu/api/threatlist/erratasec ISC_Errata
https://isc.sans.edu/api/threatlist/onyphe ISC_Onyphe
https://isc.sans.edu/api/threatlist/rapid7sonar ISC_Rapid7Sonar
https://isc.sans.edu/api/threatlist/shadowserver ISC_Shadowserver
https://isc.sans.edu/api/threatlist/shodan/ ISC_Shodan
https://raw.githubusercontent.com/stamparm/maltrail/master/trails/static/mass_scanner.txt Maltrail_Scanners_All
https://www.binarydefense.com/tor.txt BDS_TOR
https://www.dan.me.uk/torlist/?exit DMe_TOR_EN
https://rules.emergingthreats.net/blockrules/emerging-tor.rules ET_TOR_All
https://isc.sans.edu/api/threatlist/torexit ISC_TOR
https://check.torproject.org/torbulkexitlist PROJECT_TOR_EN
https://torstatus.rueckgr.at/ip_list_all.php/Tor_ip_list_ALL.csv RUECKGR_TOR_All
https://www.spamcop.net/w3m?action=map;net=cmaxratio;mask=65535;sort=spamcnt;format=text SpamCop_SC
http://toastedspam.com/deny Toastedspam
https://lists.blocklist.de/lists/apache.txt BlockListDE_Apache
https://www.blocklist.de/lists/asterisk.txt BlockListDE_Asterisk
https://lists.blocklist.de/lists/bots.txt BlockListDE_Bots
https://lists.blocklist.de/lists/bruteforcelogin.txt BlockListDE_Brute
https://www.blocklist.de/lists/email.txt BlockListDE_Email
https://lists.blocklist.de/lists/ftp.txt BlockListDE_FTP
https://www.blocklist.de/lists/proftpd.txt BlockListDE_FTPD
https://lists.blocklist.de/lists/imap.txt BlockListDE_IMAP
https://www.blocklist.de/lists/ircbot.txt BlockListDE_IRC
https://lists.blocklist.de/lists/mail.txt BlockListDE_Mail
https://www.blocklist.de/lists/pop3.txt BlockListDE_POP3
https://www.blocklist.de/lists/postfix.txt BlockListDE_Postfix
https://lists.blocklist.de/lists/sip.txt BlockListDE_SIP
https://lists.blocklist.de/lists/ssh.txt BlockListDE_SSH
https://lists.blocklist.de/lists/strongips.txt BlockListDE_Strong
https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list-raw.txt Clarketm_Proxy_IP
https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ip.txt NGOSANG_TORRENT_IP
EOF
)

# Download each list
echo "$(date +'%Y-%m-%d %H:%M:%S') - Starting download of IP lists..."
echo "$LIST" | while read -r url name; do
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Downloading $name..."
    curl -L -s -o "$WORK_DIR/$name.txt" "$url"
done
curl -L -s -o "$WORK_DIR/Alienvault.txt.gz" https://reputation.alienvault.com/reputation.snort.gz
gunzip "$WORK_DIR/Alienvault.txt.gz"
curl -L -s -o "$WORK_DIR/Nix_Spam.txt.gz" https://www.nixspam.net/download/nixspam-ip.dump.gz
gunzip "$WORK_DIR/Nix_Spam.txt.gz"
curl -L -s -o "$WORK_DIR/SFS_IPs.zip" https://www.stopforumspam.com/downloads/bannedips.zip
unzip -d "$WORK_DIR" "$WORK_DIR/SFS_IPs.zip"
rm -rf "$WORK_DIR/SFS_IPs.zip"

# Merge all files into the merged file
echo "$(date +'%Y-%m-%d %H:%M:%S') - Merging all downloaded files into $MERGED_FILE..."
cat "$WORK_DIR"/* | sort -u > "$MERGED_FILE"

echo "$(date +'%Y-%m-%d %H:%M:%S') - Filtering for IP addresses..."
grep -Po '(?<![0-9])([0-9]{1,3}\.){3}[0-9]{1,3}(\/[0-9]{1,2})?(?![0-9])' "$MERGED_FILE" | egrep -vi "^0\." | sort -u > "$FINAL_FILE"

echo "$(date +'%Y-%m-%d %H:%M:%S') - Cleaning up temporary files..."
rm -rf "$WORK_DIR"

echo "$(date +'%Y-%m-%d %H:%M:%S') - IP list generation completed. Final list is at $FINAL_FILE."
