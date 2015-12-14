# {{ title }}

{{ contents }}

{% for l in cards -%}
{% for t in l %}
    {%- if t.topic == topic -%}
        {%- for u in t -%}
            {{ u.title }}
        {%- endfor -%}
    {%- endif -%}
{%- endfor %}
{%- endfor %}