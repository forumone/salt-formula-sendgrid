# salt-formula-sendgrid
Sendgrid salt formula 
  - see pillar.example for usage

# Requirements for sendgrid_user.sh:
To run sendgrid_user.sh you will need: 

  - curl
  - jq
  - the api key - found in bitwarden
  - a name for the Sub-Account.  I suggest the host name or site name

 Note: Sub-Accounts can have multiple API Keys.


# Usage:

# on the salt master server:
sendgrid_user.sh < hostname >

# on any other server or local

sendgrid_user.sh < hostname > < api key >

you can set the API key permenatly in your environment with

echo "export sendgrid_master_api_key=< api key >" >> ~/.bash_profile


# Issues:

1. sendgrid_user.sh does not set user limits on sending emails - this is not supported via API and needs to be done manually in the admin site to do this:
  A. Log into sendgrid with the admin account
  B. Go TO: Settings > Subusers
  C. Click on the user you wish to edit
  D. click "Change Rate Limits" > select "Recurring, Month and 5,000", this is the emails per month that the account can send, allocate more if needed
2. salt does not call sendgrid_user.sh correctly and does not return subuser API Key for automatic key provisioning.
