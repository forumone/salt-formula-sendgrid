# salt-formula-sendgrid
Sendgrid salt formula

# Requirements for sendgrid_user.sh:
to run the user creation script you need to install:
- curl
- jq

need an API that has rights to send mail via Sendgrid.

run sendgrid_user.sh manually requires master api key and account name - which can be anything

usage:
./sendgrid_user.sh username master_api_key


open issues:

1. salt does not call sendgrid_user.sh correctly and does not return subuser API Key.
2. sendgrid_user.sh does not set correct rights to API key and emails do not send.
3. sendgrid_user.sh does not set user limits on sending emails.
