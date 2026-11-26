USING: bosuns-briefing.helpers kernel locals sequences ;
IN: bosuns-briefing

: roster ( names -- str )
  [ crew-line ] map "\n" join ;

: briefing ( names -- str )
  roster 
  greeting "\n" append 
  closing "\n" prepend 
  surround ;
