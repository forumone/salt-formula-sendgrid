#base config for sendgrid as email relay from postfix
#
{% set apikey = salt['pillar.get']('sendgrid:apikey', '0') %}
{% set master_api_key = salt['pillar.get']('sendgrid:master_api_key', '0') %}
{% set hostname = grains['id'] %}

{% if apikey == '0' and master_api_key == '0' %}
failure:
  test.fail:
    - name: "API Keys Not Defined"
    - failhard: True
{% endif %}

{% if master_api_key != '0' %}
    {% set apikey = salt['cmd.script']('salt://sendgrid/scripts/sendgrid_user.sh hostname master_api_key') %}
{% endif %}

##

install_packages:
  pkg.installed:
    - pkgs:
      - postfix
      - mailx

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
    - mode: 644
    - template: jinja
    - context:
        hostname: {{ hostname }}

'postmap /etc/postfix/sasl_passwd':
  cmd.wait:
    - watch:
      - file: /etc/postfix/sasl_passwd
      
{% if salt['pillar.get']('sendgrid:sendto') %}
{% set recipient = salt['pillar.get']('sendgrid:sendto') %}
'echo "sendgrid setup is working" | mailx -r donotreply@forumone.com -s "message from $(hostname)" {{ recipient }}':
  cmd.wait:
    - watch:
      - file: /etc/postfix/sasl_passwd
{% endif %} 

