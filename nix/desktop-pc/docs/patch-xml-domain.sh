#!/run/current-system/sw/bin/bash

# Run dmidecode commands and store the output
BIOS_INFO=$(sudo dmidecode --type bios)
BASEBOARD_INFO=$(sudo dmidecode --type baseboard)
SYSTEM_INFO=$(sudo dmidecode --type system)

# Extract required information
BIOS_VENDOR=$(echo "$BIOS_INFO" | grep 'Vendor' | cut -d ':' -f 2 | xargs)
BIOS_VERSION=$(echo "$BIOS_INFO" | grep 'Version' | cut -d ':' -f 2 | xargs)
BIOS_DATE=$(echo "$BIOS_INFO" | grep 'Release Date' | cut -d ':' -f 2 | xargs)

SYSTEM_MANUFACTURER=$(echo "$SYSTEM_INFO" | grep 'Manufacturer' | cut -d ':' -f 2 | xargs)
SYSTEM_PRODUCT=$(echo "$SYSTEM_INFO" | grep 'Product Name' | cut -d ':' -f 2 | xargs)
SYSTEM_VERSION=$(echo "$SYSTEM_INFO" | grep 'Version' | cut -d ':' -f 2 | xargs)
SYSTEM_SERIAL=$(echo "$SYSTEM_INFO" | grep 'Serial Number' | cut -d ':' -f 2 | xargs)
SYSTEM_UUID=$(echo "$SYSTEM_INFO" | grep 'UUID' | cut -d ':' -f 2 | xargs)
SYSTEM_FAMILY=$(echo "$SYSTEM_INFO" | grep 'Family' | cut -d ':' -f 2 | xargs)

BASEBOARD_MANUFACTURER=$(echo "$BASEBOARD_INFO" | grep 'Manufacturer' | cut -d ':' -f 2 | xargs)
BASEBOARD_PRODUCT=$(echo "$BASEBOARD_INFO" | grep 'Product Name' | cut -d ':' -f 2 | xargs)
BASEBOARD_VERSION=$(echo "$BASEBOARD_INFO" | grep 'Version' | cut -d ':' -f 2 | xargs)
BASEBOARD_SERIAL=$(echo "$BASEBOARD_INFO" | grep 'Serial Number' | cut -d ':' -f 2 | xargs)

# Generate a random MAC address
MAC_ADDRESS=$(printf '52:54:%02X:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))

# Use sed to replace values in the XML file
sed -e "s|<uuid>.*</uuid>|<uuid>$SYSTEM_UUID</uuid>|" \
    -e "s|<entry name=\"vendor\">.*</entry>|<entry name=\"vendor\">$BIOS_VENDOR</entry>|" \
    -e "s|<entry name=\"version\">.*</entry>|<entry name=\"version\">$BIOS_VERSION</entry>|" \
    -e "s|<entry name=\"date\">.*</entry>|<entry name=\"date\">$BIOS_DATE</entry>|" \
    -e "s|<entry name=\"manufacturer\">.*</entry>|<entry name=\"manufacturer\">$BASEBOARD_MANUFACTURER</entry>|" \
    -e "s|<entry name=\"product\">.*</entry>|<entry name=\"product\">$BASEBOARD_PRODUCT</entry>|" \
    -e "s|<entry name=\"version\">.*</entry>|<entry name=\"version\">$BASEBOARD_VERSION</entry>|" \
    -e "s|<entry name=\"serial\">.*</entry>|<entry name=\"serial\">$BASEBOARD_SERIAL</entry>|" \
    -e "s|<entry name=\"uuid\">.*</entry>|<entry name=\"uuid\">$SYSTEM_UUID</entry>|" \
    -e "s|<entry name=\"family\">.*</entry>|<entry name=\"family\">$SYSTEM_FAMILY</entry>|" \
    -e "s|<mac address=\".*\"/>|<mac address=\"$MAC_ADDRESS\"/>|" \
    win10.xml > win10-with-values.xml

echo "Updated configuration saved to win10-with-values.xml"

