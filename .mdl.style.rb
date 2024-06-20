# Start with all rules
all
# Don't care about line length
exclude_rule 'MD013'
# Allow headers to have the same content if they have different parents
rule 'MD024', allow_different_nesting: true
