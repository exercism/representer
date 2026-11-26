export function hey(message: string): unknown {
	let messageTrim = message.trim()
	if(messageTrim.toUpperCase() === messageTrim && !messageTrim.includes('?') && messageTrim.match(/[A-Z]/g)){
			return "Whoa, chill out!"}
	else if(messageTrim.toUpperCase() === messageTrim && messageTrim.includes('?') && messageTrim.match(/[A-Z]/g)){
			return "Calm down, I know what I'm doing!"}
	else if( messageTrim.charAt(messageTrim.length - 1) === '?'){
		return "Sure."}
	else if(messageTrim.toUpperCase() === messageTrim && !messageTrim.includes('?') && messageTrim.match(/[A-Z]/g)){
		return "Whoa, chill out!"}
	else if(messageTrim.length === 0 ){
		return "Fine. Be that way!"}
	else{
		return "Whatever."}
	}