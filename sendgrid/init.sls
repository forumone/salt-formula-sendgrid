#base config for sendgrid as email relay from postfix
#
{% set apikey =  salt['pillar.get']('apikey', '0') %}
{% set master_api_key = salt['pillar.get']('master_api_key', '0') %}
{% set hostname = grains['id'] %}

{% if apikey == '0' and master_api_key == '0' %}
  "No API Keys are Set"
{% endif %}

{% if master_api_key != '0' %}}
  {% set apikey = salt['cmd.script']('salt://sendgrid/scripts/sendgrid_user.sh {{ hostname }} {{ master_api_key }}') %}
{% endif %}


require:
  pkg.installed:
    - pkgs:
      - postfix
      - curl
      - jq
      - mailutils
      - openssl

/etc/postfix/sasl_passwd:
  file.managed:
    - source: salt://sendgrid/templates/sasl_passwd
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - context:
        apikey: {{ apikey }}

/etc/postfix/main.cf:
  file.managed:
    - source: salt://sendgrid/templates/main.cf
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - context:
        hostname: {{ hostname }}

'postmap /etc/postfix/sasl_passwd':
  cmd.run

'echo "sendgrid setup is working" | mailx -r donotreply@forumone.com -s "message from {{ hostname }}" jbernardi@forumone.com:
  cmd.run
