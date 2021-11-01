#!/bin/bash
###############################################################################
#
# Varsion    : v0.1 2021/10/29
# Owner      : Kaeruken Inc.
# Project    : Shichifukujin etc
# Descript   : 
#
###############################################################################
# ----------------------------------------
# Protocol, host and port of JOC Cockpit
JS_URL="http://localhost:5446"
 
# Identification of JobScheduler instance
JS_ID="testsuite"
# -----------------------------------------
 
 
# -----------------------------------------
# Base64 encoded string "user:password" for JOC Cockpit authentication. The below string represents "root:root"
JS_BASIC_AUTHENTICATION="`echo "root:root" | base64`"
JS_BASIC_AUTHENTICATION="${JS_BASIC_AUTHENTICATION:0:${#JS_BASIC_AUTHENTICATION}-4}"
 
# -----------------------------------------
# Perform login
echo ""
echo "PERFORMING LOGIN"
JS_JSON="`curl -k -s -S -X POST -i -m 15 -H "Authorization: Basic $JS_BASIC_AUTHENTICATION" -H "Accept: application/json" -H "Content-Type: application/json" $JS_URL/joc/api/security/login`"
JS_ACCESS_TOKEN=$(echo $JS_JSON | grep -Po '"accessToken":.*?[^\\]"' | awk -F ':' '{print $2}' | tr -d \" )
# -----------------------------------------
 
 
# -----------------------------------------
# Get orders with status "suspended"
echo ""
echo "Get suspended orders"
# Execute web service request
JS_REST_BODY="{ \"jobschedulerId\": \"$JS_ID\", \"compact\": true, \"processingStates\": [\"SUSPENDED\"] }"
JS_JSON="`curl -k -s -S -X POST -d "$JS_REST_BODY" -i -m 15 -H "X-Access-Token: $JS_ACCESS_TOKEN" -H "Accept: application/json" -H "Content-Type: application/xml" $JS_URL/joc/api/orders`"
echo $JS_JSON
# -----------------------------------------
 
 
# -----------------------------------------
 
# -----------------------------------------
# Perform logout
echo ""
echo "PERFORMING LOGOUT"
curl -k -s -S -X POST -i -m 15 -H "X-Access-Token: $JS_ACCESS_TOKEN" -H "Accept: application/json" -H "Content-Type: application/json" $JS_URL/joc/api/security/logout
# -----------------------------------------
echo ""


POST /joc/api/jobscheduler/commands HTTP/1.1
Host: localhost:4446
X-Access-Token: ce31fb8f-9f5a-4e3e-805d-72c71d0547ce
Content-Type: application/xml
Cache-Control: no-cache
Postman-Token: 88bd687a-586d-fd93-d203-bcd7e71a6a85
<jobscheduler_commands jobschedulerId='scheduler111'><add_order job_chain="/some_folder/some_chain"><params><param name="first" value="1st"/><params name="second" value="2nd"/></params></add_order></jobscheduler_commands>



