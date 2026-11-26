USING: kernel math.bits sequences sequences.extras ;
IN: secret-handshake

: commands ( number -- actions )
    5 <bits> unclip-last swap [ ] arg-where
    { "wink" "double blink" "close your eyes" "jump" }
    nths swap [ reverse ] when ;