Red [
	description: {"Secret Handshake" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

commands: function [n][
	actions: ["wink" "double blink" "close your eyes" "jump"]
    handshake: copy []

    k: 1
    while [n > 0][
    	if n and 1 = 1 [
            either k = 5 [reverse handshake][append handshake actions/:k] 
        ]
        n: n >> 1
        k: k + 1
    ]
    handshake
]

