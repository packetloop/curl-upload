export PL_ENDPOINT=https://www.packetloop.com
PL_USERNAME=username@example.com
PL_PASSWORD=password
PL_DEVICE_ID=10   #replace this number with the output of the list capture points below
UPLOAD_FILE=...

echo $PL_TOKEN
# logging in
PL_TOKEN=$(curl -k -3 -b cookies.jar -c cookies.jar -X GET "$PL_ENDPOINT/init")
echo $PL_TOKEN
curl -k -3 -s -H "X-CSRF-Token: $PL_TOKEN" -H "Content-Type: application/json" -H "Accept: application/json" -b cookies.jar -c cookies.jar -X POST "$PL_ENDPOINT/users/sign_in.json?pretty=true" -d "{ \"user\": { \"email\": \"$PL_USERNAME\", \"password\": \"$PL_PASSWORD\" } }"
# list capture points
curl -k -3 -s -H "Accept: application/json" -b cookies.jar -c cookies.jar -X GET "$PL_ENDPOINT/devices.json?pretty=true"


