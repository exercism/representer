-module(palindrome_products).

-export([largest/2, smallest/2]).

%% Find the largest palindrome product in the range
largest(Min, Max) when Min > Max ->
    error(invalid_range);
largest(Min, Max) ->
    find_palindromes(Min, Max, largest).

%% Find the smallest palindrome product in the range
smallest(Min, Max) when Min > Max ->
    error(invalid_range);
smallest(Min, Max) ->
    find_palindromes(Min, Max, smallest).

%% Main function to find palindromes
find_palindromes(Min, Max, Type) ->
    % Generate all products and check for palindromes
    Palindromes = find_all_palindromes(Min, Max),
    case Palindromes of
        [] -> undefined;
        _ -> 
            case Type of
                smallest -> lists:min(Palindromes);
                largest -> lists:max(Palindromes)
            end
    end.

%% Find all palindromic products with their factors
find_all_palindromes(Min, Max) ->
    % Create a map to collect all factor pairs for each palindrome
    PalindromeMap = collect_palindromes(Min, Max, #{}),
    % Convert map to list of {palindrome, factors} tuples
    maps:fold(fun(Palindrome, Factors, Acc) ->
        [{Palindrome, Factors} | Acc]
    end, [], PalindromeMap).

%% Collect all palindromic products and their factor pairs
collect_palindromes(Min, Max, PalindromeMap) ->
    collect_palindromes_helper(Min, Min, Max, PalindromeMap).

collect_palindromes_helper(I, Min, Max, PalindromeMap) when I > Max ->
    PalindromeMap;
collect_palindromes_helper(I, Min, Max, PalindromeMap) ->
    % For each I, check products with J where J >= I (to avoid duplicates)
    NewMap = collect_products_for_i(I, I, Max, PalindromeMap),
    collect_palindromes_helper(I + 1, Min, Max, NewMap).

collect_products_for_i(I, J, Max, PalindromeMap) when J > Max ->
    PalindromeMap;
collect_products_for_i(I, J, Max, PalindromeMap) ->
    Product = I * J,
    case is_palindrome(Product) of
        true ->
            % Add this factor pair to the palindrome
            Factors = maps:get(Product, PalindromeMap, []),
            NewFactors = [{I, J} | Factors],
            NewMap = maps:put(Product, NewFactors, PalindromeMap),
            collect_products_for_i(I, J + 1, Max, NewMap);
        false ->
            collect_products_for_i(I, J + 1, Max, PalindromeMap)
    end.

%% Check if a number is a palindrome
is_palindrome(N) ->
    Str = integer_to_list(N),
    Str =:= lists:reverse(Str).