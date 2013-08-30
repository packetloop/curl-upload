export PL_ENDPOINT=https://www.packetloop.com
PL_USERNAME=username@example.com
PL_PASSWORD=password
PL_DEVICE_ID=10
UPLOAD_FILE=capture.pcap   #Path to your capture file

echo $PL_TOKEN
# logging in
PL_TOKEN=$(curl -k -3 -b cookies.jar -c cookies.jar -X GET "$PL_ENDPOINT/init")
echo $PL_TOKEN
curl -k -3 -s -H "X-CSRF-Token: $PL_TOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -b cookies.jar -c cookies.jar -X POST "$PL_ENDPOINT/users/sign_in.json?pretty=true" -d "{ \"user\": { \"email\": \"$PL_USERNAME\", \"password\": \"$PL_PASSWORD\" } }"
# list capture points
curl -k -3 -s -H "Accept: application/json" -b cookies.jar -c cookies.jar -X GET "$PL_ENDPOINT/devices.json?pretty=true"

# upload file(s)
IDS=()
IDS+=($(curl -k -3 -s -H "X-CSRF-Token: $PL_TOKEN" -H "Accept: application/json" -b cookies.jar -c cookies.jar -X POST "$PL_ENDPOINT/settings/captures.json?device_id=$PL_DEVICE_ID" -F "file=@$UPLOAD_FILE" | sed -e 's/.*://' -e 's/}//'))

# submit uploads
IDS_ARRAY=$(printf ",%s" "${IDS[@]}")
IDS_ARRAY=${IDS_ARRAY:1}
IDS_ARRAY="[$IDS_ARRAY]"
curl -k -3 -s -H "X-CSRF-Token: $PL_TOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -b cookies.jar -c cookies.jar -X PUT "$PL_ENDPOINT/settings/captures/submit.json" -d "{ \"ids\": $IDS_ARRAY, \"device_id\": \"$PL_DEVICE_ID\" }"

# get status
curl -k -3 -s -H "X-CSRF-Token: $PL_TOKEN" -H "Accept: application/json" -b cookies.jar -c cookies.jar -X GET "$PL_ENDPOINT/upload/status.json?pretty=true"

