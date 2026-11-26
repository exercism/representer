#ifndef WORDCOUNT_H
#define WORDCOUNT_H

#include <boost/algorithm/string.hpp>
#include <iterator>
#include <map>
#include <regex>
#include <vector>

namespace word_count {

inline std::map<std::string, int> words(std::string const &input)
{
	std::map<std::string, int> output;

	std::string input_lowered(input);
	std::transform(input.begin(), input.end(), input_lowered.begin(),
	               ::tolower);
	std::vector<std::string> tokens;
	boost::split(
	    tokens, input_lowered,
	    boost::is_any_of(" \t\n\r!@#$%^&*(),./;[]\\<>?:\"{}|-=_+"));

	for (auto const &token : tokens)
	{
		std::regex word_regex(".*[^\'].*");

		if (!token.empty() && std::regex_match(token, word_regex))
		{
			std::string trimmed_token = std::regex_replace(
			    token, std::regex("^\'*(.*?)\'*$"), "$1");
			output[trimmed_token] += 1;
		}
	}

	return output;
}

}

#endif // WORDCOUNT_H