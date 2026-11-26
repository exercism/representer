unit module ResistorColorDuo;

sub decoded-value ( *@colors ) is export {
    +@colors[^3].map({<black brown red orange yellow green blue violet grey white>.pairs.invert.Map{$_}}).join
}
