#!/bin/bash

CURL_OPTS="--ipv4"
TARGET_HOST=$1
TARGET_PORT=$2
if [ -z "${TARGET_PORT}" ]; then
    TARGET_PORT="2980"
fi
if [ -z "${TARGET_HOST}" ]; then
    TARGET_HOST="localhost"
fi
BASE_URL="http://${TARGET_HOST}:${TARGET_PORT}"
curl -L --ipv4 --silent -m 5 "$BASE_URL" > /dev/null
if [ $? -ne 0 ]; then
    echo "Connect failed: ${BASE_URL}"
    echo "Usage: $0 <TARGET_HOST> [TARGET_PORT]"
    exit 1
fi

function test_request() {
    local TARGET_METHOD=$1
    local TARGET_URL=$2
    local DATA_TO_SEND=$3
    local EXPECTED_RESPONSE=$4
    local RESPONSE=`curl -S $CURL_OPTS -X"${TARGET_METHOD}" --data "${DATA_TO_SEND}" "${TARGET_URL}" 2>/dev/null`
    local RETVAL="$?"
    echo "-TEST------------------------"
    echo "SENT: $TARGET_METHOD $TARGET_URL"
    echo "DATA: $DATA_TO_SEND"
    echo "RECV: $RESPONSE"
    if [ ${RETVAL} -ne 0 ]; then
        echo "FAILURE: Request failed"
        return 1
    fi
    if [ "${RESPONSE}" != "${EXPECTED_RESPONSE}" ]; then
        echo "FAILURE: Unexpected response. Expected: ${EXPECTED_RESPONSE}"
        return 2
    fi
    echo "SUCCESS"
}

METHOD="PUT"
URL="${BASE_URL}/profile"
test_request $METHOD $URL "BAD_DATA" '{"error":400,"message":"Malformed request"}' || exit 1
test_request $METHOD $URL '{"age": 230,"burger":15}' '{"error":400,"message":"Field required: name"}' || exit 1
test_request $METHOD $URL '{"name":"tutumbr","bocha":115}' '{"error":400,"message":"Field required: age"}' || exit 1
test_request $METHOD $URL '{"name":"gibson","age":230}' '{"profile_id":"1","error":0,"message":""}' || exit 1
test_request $METHOD $URL '{"name":"bambr","age":54}' '{"profile_id":"2","error":0,"message":""}' || exit 1
test_request $METHOD $URL '{"name":"zyapta","age":826}' '{"profile_id":"3","error":0,"message":""}' || exit 1
METHOD="GET"
test_request $METHOD "${URL}/1" '' '{"profile_id":"1","name":"gibson","age":"230","error":0,"message":""}' || exit 1
test_request $METHOD "${URL}/2" '' '{"profile_id":"2","name":"bambr","age":"54","error":0,"message":""}' || exit 1
test_request $METHOD "${URL}/3" '' '{"profile_id":"3","name":"zyapta","age":"826","error":0,"message":""}' || exit 1
test_request $METHOD "${URL}/4" '' '{"error":404,"message":"Profile not found"}' || exit 1
METHOD="DELETE"
test_request $METHOD "${URL}/1" '' '{"profile_id":"1","error":0,"message":""}' || exit 1
test_request $METHOD "${URL}/2" '' '{"profile_id":"2","error":0,"message":""}' || exit 1
test_request $METHOD "${URL}/3" '' '{"profile_id":"3","error":0,"message":""}' || exit 1
test_request $METHOD "${URL}/4" '' '{"error":404,"message":"Profile not found"}' || exit 1
METHOD="GET"
test_request $METHOD "${URL}/1" '' '{"error":404,"message":"Profile not found"}' || exit 1
METHOD="DELETE"
test_request $METHOD "${URL}/1" '' '{"error":404,"message":"Profile not found"}' || exit 1
echo "ALL TESTS PASSED"
