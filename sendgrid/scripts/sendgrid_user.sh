#!/usr/bin/env bash
#
# makes API calls to sendgrid to create user and api key.  Using minion hostname as the username and senind all data to a sasl_password file for postfix.
#
#Some Variables that could be changed
#
master_api_key=$2
hostname=$1
limits=1000
password=$(openssl rand -base64 32)
ip=149.72.187.229
#
# the rest is should be self explanatory 
#

if [[ -z $master_api_key ]]
then 
#echo "please enter master API key"
exit 1
fi

if [[ -z $hostname ]]
then
#echo "no hostname provided"
exit 1
fi

# taking out the user part - just make a new api key if user exists 
#users=$(curl -s -X "GET" "https://api.sendgrid.com/v3/subusers" -H "Authorization: Bearer $master_api_key" -H "Content-Type: application/json" | jq -r '.[].username')

#user=$(echo $users | grep -ow $hostname)

#if [[ $hostname == $user ]]
#then
#echo $n
#echo "user exists"
#exit 1
#fi

generate_post_data()
{
cat <<EOF
{
    "username":"$hostname",
    "email":"$hostname@forumone.com",
    "password":"$password",
    "ips":["$ip"]
}
EOF
}

curl -s -X POST --url 'https://api.sendgrid.com/v3/subusers' \
-H "authorization: Bearer $master_api_key" \
-H 'content-type: application/json' \
-d "$(generate_post_data)" > /dev/null

api_key=$(curl -s --request POST \
  --url https://api.sendgrid.com/v3/api_keys \
  --header "authorization: Bearer $master_api_key" \
  --header 'content-type: application/json' \
  --header "on-behalf-of: $hostname" \
  --data '{"name":"postfix"}' | jq -r '.api_key'
)
check=$(echo $api_key | grep -ow 'SG.')

if [[ -z $check ]]
then
exit 1
else 
echo $api_key
fi