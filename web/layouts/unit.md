# {{ title }}
unit: {{ unit }}
unittopic: {{ unittopic }}
{{#each cards}}
{{#is cardtopic "===" unittopic}}
unittopic: {{ unittopic }}
cardtopic: {{ cardtopic }}
cardunit: {{ cardunit }}
{{#each_when this "test" "test"}}
cardunit: {{ cardunit }}
{{#each this}}
{{ contents }}
# 
{{/each}}
{{/each_when}}
{{/is}}
{{/each}}
