Hi I'm a unit!
{{ unit }}
{{ unittopic }}
{{#each_when cards "cardtopic" unittopic}}
cardtopic: {{ cardtopic }}
{{#each_when this cardunit unit}}
cardunit:  {{ cardunit }}
{{#each this}}
{{ contents }}
# 
{{/each}}
{{/each_when}}
{{/each_when}}

# each cards
{{#each cards}}
cardtopic: {{ cardtopic }}
{{#each this}}
cardunit:  {{ cardunit }}
{{#each this}}
card:      {{!--  contents --}}
{{/each}}
{{/each}}
{{/each}}

# each units
{{#each units}}
unittopic: {{ unittopic }}
{{#each this}}
unit:      {{ unit }}
{{/each}}
{{/each}}
