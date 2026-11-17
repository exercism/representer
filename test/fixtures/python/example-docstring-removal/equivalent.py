""" This module helps little sister with her vocabulary homework.

    And this is a multi-line module level docstring. It should be
    removed when the representation is processed.
 """

def placeholder_0(placeholder_1):
    """

    :param word: str of a root word
    :return:  str of root word with un prefix

    This function takes `word` as a parameter and
    returns a new word with an 'un' prefix.
    """
    return 'un' + placeholder_1

def placeholder_2(placeholder_3):
    """Create word groups from a list of vocab words.

    :param vocab_words: list of vocabulary words with a prefix.
    :return: str of prefix followed by vocabulary words with
             prefix applied, separated by ' :: '.

    This function takes a `vocab_words` list and returns a string
    with the prefix  and the words with prefix applied, separated
     by ' :: '.
    """
    placeholder_4 = 'This is a multi-line string.\n    This should NOT get cleaned as a docstring, but retained, because it is assigned\n    a name, and is therefore a plain string, and not a docstring.'
    return (' :: ' + placeholder_3[0]).join(placeholder_3)

def placeholder_5(placeholder_1):
    """Remove the suffix of a word.

    :param word: str of word to remove suffix from.
    :return: str of word with suffix removed & spelling adjusted.

    This function takes in a word and returns the base word with `ness` removed.
    """
    placeholder_6 = 'This is a multi-line string constant.\n       This should NOT get cleaned as a docstring, but retained, because it is assigned\n       a name, and is therefore a plain string, and not a docstring.'
    return placeholder_1[:-4] if placeholder_1[-5] != 'i' else placeholder_1[:-5] + 'y'

def placeholder_7(placeholder_8, placeholder_9):
    """Turn an adjective form into a verb form.

    :param sentence: str that uses the word in sentence
    :param index:  index of the word to remove and transform
    :return:  str word that changes the extracted adjective to a verb.

    A function takes a `sentence` using the
    vocabulary word, and the `index` of the word once that sentence
    is split apart.  The function should return the extracted
    adjective as a verb.
    """
    return placeholder_8.split()[placeholder_9].strip('.') + 'en'

def placeholder_10():
    """Generate a list of formatted report strings for tournament results.

         >>> test = (tally(["Courageous Californians;Devastating Donkeys;win",                            "Allegoric Alaskans;Blithering Badgers;win",                            "Devastating Donkeys;Allegoric Alaskans;loss",                            "Courageous Californians;Blithering Badgers;win",                            "Blithering Badgers;Devastating Donkeys;draw",                            "Allegoric Alaskans;Courageous Californians;draw"]))
         >>> print(type(test))
         <class 'list'>
         >>> print(test[0])
         Team                           | MP |  W |  D |  L |  P
         >>> print(test[1])
         Allegoric Alaskans             |  3 |  2 |  1 |  0 |  7
         >>> print(test[2])
         Courageous Californians        |  3 |  2 |  1 |  0 |  7
         >>> print(test[3])
         Blithering Badgers             |  3 |  0 |  1 |  2 |  1
         >>> print(test[4])
         Devastating Donkeys            |  3 |  0 |  1 |  2 |  1
        """
    try:
        placeholder_11 = (placeholder_12.split(';') for placeholder_12 in tournament_results)
        placeholder_13 = compile_statistics(placeholder_11)
    except AttributeError:
        logger.exception(f'There is a problem with the tournament results string: ')
        raise
    except IndexError:
        logger.exception(f'Compiling team statistics failed: ')
        raise
    return make_report(placeholder_13)

class placeholder_14:
    """Concrete date type.

    Constructors:

    __new__()
    fromtimestamp()
    today()
    fromordinal()

    Operators:

    __repr__, __str__
    __eq__, __le__, __lt__, __ge__, __gt__, __hash__
    __add__, __radd__, __sub__ (add/radd only with timedelta arg)

    Methods:

    timetuple()
    toordinal()
    weekday()
    isoweekday(), isocalendar(), isoformat()
    ctime()
    strftime()

    Properties (readonly):
    year, month, day
    """
    __slots__ = ('_year', '_month', '_day', '_hashcode')

    def __new__(placeholder_17, placeholder_18, placeholder_19=None, placeholder_20=None):
        """Constructor.

        Arguments:

        year, month, day (required, base 1)
        """
        if placeholder_19 is None and isinstance(placeholder_18, (bytes, str)) and (len(placeholder_18) == 4) and (1 <= ord(placeholder_18[2:3]) <= 12):
            if isinstance(placeholder_18, str):
                try:
                    placeholder_18 = placeholder_18.encode('latin1')
                except UnicodeEncodeError:
                    raise ValueError("Failed to encode latin1 string when unpickling a date object. pickle.load(data, encoding='latin1') is assumed.")
            self = object.__new__(placeholder_17)
            self.__setstate(placeholder_18)
            self.placeholder_21 = -1
            return self

def placeholder_22():
    """This s a docstring-only function.

    It is valid, but only because of the docstring (an Expr).
    Removing the docstring creates a fatal error during formatting
    if the docstring is not replaced with pass.
    """

class placeholder_23:
    """This is a docstring-only class.

    It should be normalized in the same way the function
    def above is normalized.
    """

class placeholder_24:
    """This is a docstring-only class with a docstring-only method.

    This should be normalized with a pass for
    the class and a pass for the method.

    """

    def placeholder_25(self):
        """This is a docstring only method.

        This should be normalized with a pass.
        """

def placeholder_26():
    """Function using an Ellipsis object.

    This is a def that uses a docstring and an ellipsis in luie 
    of pass.  The normalizer should remove the docstring but keep 
    the ellipsis.
    """
    ...

class placeholder_24:
    """This is a docstring class with a docstring method.

    Ellipsis is used for a code placeholder.
    This should be normalized with the Ellipsis retained.

    """
    ...

    def placeholder_25(self):
        """This is a docstring with Ellipsis method.

        This should be normalized with the Ellipsis retained.
        """
        ...
