#!/bin/sh

# Working directory
WORK_DIR="work"
mkdir -p "$WORK_DIR"

# Temporary merged file
MERGED_FILE="$WORK_DIR/merged.txt"

# Output file for pfBlockerNG
FINAL_FILE="list.txt"

# Define URLs and names directly in the script
LIST=$(cat <<'EOF'
https://easylist-downloads.adblockplus.org/easylist_noelemhide.txt EasyList
https://easylist-downloads.adblockplus.org/easylistchina.txt EasyList_Chinese
https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt EasyList_CJX
https://raw.githubusercontent.com/tomasko126/easylistczechandslovak/master/filters.txt EasyList_Czech_Slovak
https://easylist-downloads.adblockplus.org/easylistdutch.txt EasyList_Dutch
https://raw.githubusercontent.com/finnish-easylist-addition/finnish-easylist-addition/gh-pages/Finland_adb.txt EasyList_Finland
https://easylist-downloads.adblockplus.org/liste_fr.txt EasyList_French
https://easylist.to/easylistgermany/easylistgermany.txt EasyList_German
https://www.void.gr/kargig/void-gr-filters.txt EasyList_Greek
https://raw.githubusercontent.com/easylist/EasyListHebrew/master/EasyListHebrew.txt EasyList_Hebrew
https://raw.githubusercontent.com/heradhis/indonesianadblockrules/master/subscriptions/abpindo.txt EasyList_Indonesian
https://easylist-downloads.adblockplus.org/easylistitaly.txt EasyList_Italian
https://raw.githubusercontent.com/k2jp/abp-japanese-filters/master/abp_jp.txt EasyList_Japanese
https://raw.githubusercontent.com/EasyList-Lithuania/easylist_lithuania/master/easylistlithuania.txt EasyList_Lithuanian
https://raw.githubusercontent.com/MajkiIT/polish-ads-filter/master/polish-adblock-filters/adblock.txt EasyList_Polish
https://easylist-downloads.adblockplus.org/easylistportuguese.txt EasyList_Portuguese
https://easylist-downloads.adblockplus.org/ruadlist.txt EasyList_Russian
https://easylist-downloads.adblockplus.org/easylistspanish.txt EasyList_Spanish
https://filters.adtidy.org/windows/filters/13.txt EasyList_Turkish
https://raw.githubusercontent.com/abpvn/abpvn/master/filter/abpvn.txt EasyList_Vietnamese
https://easylist-downloads.adblockplus.org/liste_ar.txt EasyList_Arabic
https://stanev.org/abp/adblock_bg.txt EasyList_Bulgarian
https://easylist.to/easylist/easyprivacy.txt EasyPrivacy
https://adaway.org/hosts.txt Adaway
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt D_Me_ADs
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt D_Me_Tracking
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml Yoyo
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts StevenBlack_ADs
https://raw.githubusercontent.com/bambenek/block-doh/master/doh-hosts.txt Bambenek_DoH
https://raw.githubusercontent.com/dibdot/DoH-IP-blocklists/master/doh-domains.txt Dibdot_DoH
https://raw.githubusercontent.com/oneoffdallas/dohservers/master/list.txt Oneoffdallas_DoH
https://raw.githubusercontent.com/Sekhan/TheGreatWall/master/TheGreatWall.txt TheGreatWall_DoH
https://urlhaus.abuse.ch/downloads/hostfile/ Abuse_urlhaus
https://isc.sans.edu/feeds/suspiciousdomains_High.txt ISC_SDH
https://raw.githubusercontent.com/openphish/public_feed/refs/heads/main/feed.txt OpenPhish
https://v.firebog.net/hosts/Easyprivacy.txt Easyprivacy
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts FadeMind_2o7Net
https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt Frogeye_First
https://hostfiles.frogeye.fr/multiparty-trackers-hosts.txt Frogeye_Multi
https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt Lightswitch05
https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt Max_MS
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt Perflyst_Android
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt Perflyst_FireTV
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt Perflyst_TV
https://v.firebog.net/hosts/Prigent-Ads.txt Prigent_Ads
https://v.firebog.net/hosts/AdguardDNS.txt Adguard_DNS
https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts Ad_Wars
https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt Anudeep_BL
https://v.firebog.net/hosts/Easylist.txt Easylist_FB
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts Fademinds
https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts hostsVN
https://v.firebog.net/hosts/Admiral.txt LanikSJ
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext PL_Adservers
https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt APT1_Report
https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt DandelionSprouts
https://phishing.army/download/phishing_army_blocklist_extended.txt Phishing_Army
https://v.firebog.net/hosts/Prigent-Crypto.txt Prigent_Crypto
https://raw.githubusercontent.com/HorusTeknoloji/TR-PhishingList/master/url-lists.txt Turkey_High_Risk
https://urlhaus.abuse.ch/downloads/hostfile/ URLhaus_Mal
https://v.firebog.net/hosts/Prigent-Malware.txt Prigent_Malware
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts Risky_Hosts
https://raw.githubusercontent.com/edwin-zvs/email-providers/master/email-providers.csv Edwin_Email
https://raw.githubusercontent.com/stamparm/aux/master/maltrail-malware-domains.txt Maltrail_BD
https://www.stopforumspam.com/downloads/toxic_domains_whole.txt SFS_Toxic_BD
https://raw.githubusercontent.com/Dawsey21/Lists/master/main-blacklist.txt Spam404
https://someonewhocares.org/hosts/hosts SWC
https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt D_Me_Malv
https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt D_Me_Malw
https://winhelp2002.mvps.org/hosts.txt MVPS
https://threatfox.abuse.ch/downloads/hostfile/ Abuse_ThreatFox
https://raw.githubusercontent.com/TheAntiSocialEngineer/AntiSocial-BlockList-UK-Community/main/UK-Community.txt AntiSocial_UK_BD
https://www.joewein.net/dl/bl/dom-bl-base.txt Joewein_base
https://www.joewein.net/dl/bl/dom-bl.txt Joewein_new
https://raw.githubusercontent.com/azet12/KADhosts/master/KADhosts.txt KAD_BD
https://list.kwbt.de/fritzboxliste.txt Kowabit
https://raw.githubusercontent.com/stamparm/blackbook/master/blackbook.txt Maltrail_Blackbook
https://raw.githubusercontent.com/piwik/referrer-spam-blacklist/master/spammers.txt Piwik_Spam
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt Quidsup_Mal
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt Quidsup_Trackers
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts StevenBlack_BD
http://vxvault.net/URL_List.php VXVault
https://raw.githubusercontent.com/Yhonay/antipopads/master/hosts Yhonay_BD
https://raw.githubusercontent.com/vokins/yhosts/master/hosts.txt yHosts
https://www.botvrij.eu/data/ioclist.domain.raw Botvrij_Dom
https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts Krog_BD
https://raw.githubusercontent.com/gwillem/magento-malware-scanner/master/rules/burner-domains.txt Magento
https://raw.githubusercontent.com/anudeepND/blacklist/master/facebook.txt Anudeep_Facebook
https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_all.list Chad_Mayfield
https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_top1m.list Chad_Mayfield_1M
https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt BarbBlock
https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt KADhosts
https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/basic/hosts neoHosts
https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt SNAFU_List
https://someonewhocares.org/hosts/zero/hosts SWC
https://v.firebog.net/hosts/static/w3kbl.txt WaLLy3Ks
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts FM_Spam
https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt Matomo_Spam
https://big.oisd.nl OISD_BIG
https://nsfw.oisd.nl OISD_NSFW
https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt NoCoin
https://raw.githubusercontent.com/Hestat/minerchk/master/hostslist.txt MoneroMiner
https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt NGOSANG_TORRENT
http://enumer.org/public-stun.txt ENUMER_STUN
https://gist.githubusercontent.com/BBcan177/4a8bf37c131be4803cb2/raw MS_2
EOF
)

# Download each list
echo "$LIST" | while read -r url name; do
    echo "Downloading $name..."
    curl -s -o "$WORK_DIR/$name.txt" "$url"
done
wget -q -O "$WORK_DIR/PhishTank.bz2" "https://data.phishtank.com/data/online-valid.csv.bz2"
bzip2 -d "$WORK_DIR/PhishTank.bz2"

# Merge all files into the merged file
echo "Merging all downloaded files into $MERGED_FILE..."
cat "$WORK_DIR"/* | grep -v 'phishtank' > "$MERGED_FILE"

echo "Filtering for pfBlockerNG/DNSBL domains and ip addresses..."
grep -hPo '\b(?:(?:25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\b' "$MERGED_FILE" | sort -u > "$FINAL_FILE"
grep -hPo '(?:\*\.)?(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}' "$MERGED_FILE" | sort -u >> "$FINAL_FILE"

echo "Cleaning up temporary files..."
# Remove all txt files except list.txt
rm -rf "$WORK_DIR"

echo "Done. Final list saved in $FINAL_FILE."
