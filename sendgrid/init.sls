#base config for sendgrid as email relay from postfix
#

sendgrid dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - jq
      - mailutils
      - openssl

{% set hostname = grains['id'] %}
{% set apikey = salt['cmd.script.retcode']('salt://sendgrid/scripts/sendgrid_user.sh {{ hostname }}') %}

/etc/postfix/sasl_passwd:
  file.managed:
    - source: salt://sendgrid/templates/sasl_passwd
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - context:
        apikey: {{ apikey }}

'postmap /etc/postfix/sasl_passwd':
  cmd.run


