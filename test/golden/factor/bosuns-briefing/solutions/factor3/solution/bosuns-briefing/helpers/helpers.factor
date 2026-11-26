USE: formatting
IN: bosuns-briefing.helpers

CONSTANT: greeting "All hands, attention!"
CONSTANT: closing "Carry on."

: crew-line ( name -- str )
    "  - %s" sprintf ;
