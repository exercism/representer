import string

def abbreviate(words: str) -> str:
    """
    Converts a phrase into its acronym.
    
    Args:
        words: The input phrase (string).
        
    Returns:
        The acronym of the phrase (string).
    """
    # Replace hyphens with spaces
    processed = words.replace('-', ' ')
    
    # Remove punctuation and keep only alphanumeric and spaces
    cleaned = ''.join(c for c in processed if c.isalnum() or c.isspace())
    
    # Split into words and get first letters
    acronym = ''.join(word[0].upper() for word in cleaned.split() if word)
    
    return acronym

