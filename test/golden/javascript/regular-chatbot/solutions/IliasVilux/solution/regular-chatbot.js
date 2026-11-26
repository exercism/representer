// @ts-check

/**
 * Given a certain command, help the chatbot recognize whether the command is valid or not.
 *
 * @param {string} command
 * @returns {boolean} whether or not is the command valid
 */

export function isValidCommand(command) {
  let asd = command.match(/chatbot/i);
  if(asd != null && asd.index == 0) {
    return true;
  }
  return false
}

/**
 * Given a certain message, help the chatbot get rid of all the emoji's encryption through the message.
 *
 * @param {string} message
 * @returns {string} The message without the emojis encryption
 */
export function removeEmoji(message) {
  let regex = new RegExp(/emoji\d+/, 'gi');
  return message.replace(regex, '');
}

/**
 * Given a certain phone number, help the chatbot recognize whether it is in the correct format.
 *
 * @param {string} number
 * @returns {string} the Chatbot response to the phone Validation
 */
export function checkPhoneNumber(number) {
  let regex = /\(\+\d{2}\) \d{3}-\d{3}-\d{3}/
  const mssgOk = 'Thanks! You can now download me to your phone.', mssgErr = `Oops, it seems like I can\'t reach out to ${number}`

  return regex.test(number) ? mssgOk : mssgErr
}

/**
 * Given a certain response from the user, help the chatbot get only the URL.
 *
 * @param {string} userInput
 * @returns {string[] | null} all the possible URL's that the user may have answered
 */
export function getURL(userInput) {
  let regex = /\w+\.\w+/g
  return userInput.match(regex)
}

/**
 * Greet the user using the full name data from the profile.
 *
 * @param {string} fullName
 * @returns {string} Greeting from the chatbot
 */
export function niceToMeetYou(fullName) {
  let regex = fullName.split(/,/)
  return `Nice to meet you,${regex[1]} ${regex[0]}`
}
