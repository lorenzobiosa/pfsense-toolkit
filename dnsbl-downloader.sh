#!/bin/sh

# Working directory
WORK_DIR="work"
mkdir -p "$WORK_DIR"

# Temporary merged file
MERGED_FILE="$WORK_DIR/merged.txt"

# Output file for pfBlockerNG
FINAL_FILE="$WORK_DIR/list.txt"

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
https://easylist-downloads.adblockplus.org/advblock.txt EasyList_Russian
https://easylist-downloads.adblockplus.org/easylistspanish.txt EasyList_Spanish
https://adguard.com/en/filter-rules.html?id=13 EasyList_Turkish
https://raw.githubusercontent.com/abpvn/abpvn/master/filter/abpvn.txt EasyList_Vietnamese
https://easylist-downloads.adblockplus.org/Liste_AR.txt EasyList_Arabic
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
https://data.phishtank.com/data/online-valid.csv.bz2 PhishTank
EOF
)

# Download each list
echo "$LIST" | while read -r url name; do
    echo "Downloading $name..."
    curl -s -o "$WORK_DIR/$name.txt" "$url"
done

# Merge all files into the merged file
echo "Merging all downloaded files into $MERGED_FILE..."
cat "$WORK_DIR"/*.txt > "$MERGED_FILE"

echo "Filtering for pfBlockerNG/DNSBL domains and ip addresses..."
grep -hPo '\b(?:(?:25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\b' "$MERGED_FILE" | sort -u > "$FINAL_FILE"
grep -hPo '(?:\*\.)?(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}' "$MERGED_FILE" | sort -u >> "$FINAL_FILE"

echo "Cleaning up temporary files..."
# Remove all txt files except list.txt
find "$WORK_DIR" -type f -name "*.txt" ! -name "list.txt" -delete

echo "Done. Final list saved in $FINAL_FILE."
