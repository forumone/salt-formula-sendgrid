#base config for sendgrid as email relay from postfix
#
include:
  - postfix

require:
  - pkg: curl
  - pkg: jq
  - pkg: cyrus-sasl-plain

{% set hostname = grains['id'] %}
{% set apikey = ['cmd.run']('salt://sendgrid/scripts/sendgrid_user.sh {{ hostname }}') %}

postfix:
  config:
    relayhost: "[smtp.sendgrid.net]:587"
    smtp_sasl_auth_enable: yes
    smtp_sasl_password_maps: hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options: noanonymous
    smtp_sasl_tls_security_options: noanonymous
    smtp_tls_security_level: encrypt
    header_size_limit: 4096000

/etc/postfix/sasl_passwd:
  file.managed:
    - source: salt://sendgrid/templates/sasl_passwd
    - user: root
    - group: root
    - mode: 600
    - context:
      password: {{ apikey }}

'postmap /etc/postfix/sasl_passwd':
  - cmd.run:

postfix:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: postfix