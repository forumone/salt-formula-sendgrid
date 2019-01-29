# salt-formula-sendgrid
Sendgrid salt formula

# Requirements for sendgrid_user.sh:
to run the user creation script you need to install:
- curl
- jq
- An API key  that has rights to create subusers and API Keys.

To run sendgrid_user.sh manually the api key and account name of your choosing I suggest the site or host name so you know where emails are coming from. Sub-Accounts can have multiple API Keys.

usage:
./sendgrid_user.sh username master_api_key


open issues:

1. salt does not call sendgrid_user.sh correctly and does not return subuser API Key.
2. sendgrid_user.sh does not set correct rights to API key and emails do not send.
3. sendgrid_user.sh does not set user limits on sending emails.
