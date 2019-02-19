# salt-formula-sendgrid
Sendgrid salt formula - see pillar.example for usage

# Requirements for sendgrid_user.sh:
to run the user creation script you need to install:
- curl
- jq
- An API key  that has rights to create subusers and API Keys.

To run sendgrid_user.sh manually the api key and account name of your choosing I suggest the site or host name so you know where emails are coming from. Sub-Accounts can have multiple API Keys.


usage:

on the salt master server:
sendgrid_user.sh < hostname >

on any other server or local

sendgrid_user.sh < hostname > < user create api key >

you can set the API key in your environment with

echo "export sendgrid_master_api_key=< user create api key >" >> ~/.bash_profile


open issues:

1. salt does not call sendgrid_user.sh correctly and does not return subuser API Key.
2. sendgrid_user.sh does not set user limits on sending emails - this is not supported via API and needs to be done manually in the admin site to do this:
  1. Log into sendgrid with the admin account
  2. Go TO: Settings > Subusers
  3. Click on the user you wish to edit
  4. click "Change Rate Limits" > select "Recurring, Month and 5,000", this is the emails per month that the account can send, allocate more if needed
