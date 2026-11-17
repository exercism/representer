""" Dataclasses:
    Example code, that demonstrates the new `slots` and
    the `keyword-only` features of dataclasses.

    The slots option is invoked as a parameters to the dataclass decorator.

    Key-words are demonstrated 3 ways:
       *** as a parameters to @dataclass,
       *** as a parameters to field(),
       *** as a sentinel value

    Some of these constructs caused nasty Error cases for the representer.

    Using Slots=True Frozen=True with uninitialized variables via typehint
    in dataclasses causes a
    AttributeError: 'NoneType' object has no attribute '_fields'
    When the result is parsed by generic_visit(node).

    More error scenarios are commented/noted above the construct.

    # See the following dataclasses issues for more information
    # https://github.com/python/cpython/blob/main/Lib/dataclasses.py#L1015-L1029
    # https://github.com/python/cpython/issues/98247
    # https://github.com/python/cpython/issues/89529
    # https://github.com/python/cpython/issues/132946
    # https://github.com/python/cpython/issues/132559
    # https://github.com/python/cpython/issues/135797
    # https://github.com/python/cpython/issues/98247
"""
from dataclasses import dataclass, field, KW_ONLY

@dataclass
class placeholder_0:
    ...

@dataclass()
class placeholder_0:
    ...

@dataclass(init=True, repr=True, eq=True, order=False, unsafe_hash=False, frozen=False, match_args=True, kw_only=False, slots=False, weakref_slot=False)
class placeholder_0:
    ...

@dataclass
class placeholder_0:
    pass

@dataclass
class placeholder_10:
    placeholder_11: int
    placeholder_12: int
    placeholder_13: int

@dataclass
class placeholder_14:
    placeholder_15: float = 0.0
    placeholder_16: float = 0.0

@dataclass
class placeholder_17:
    placeholder_18: int
    placeholder_19: int | None = None
    placeholder_20: InitVar[DatabaseType | None] = None

    def __post_init__(self, placeholder_20):
        if self.placeholder_19 is None and placeholder_20 is not None:
            self.placeholder_19 = placeholder_20.lookup('j')
placeholder_22 = make_dataclass('C', [('x', int), 'y', ('z', int, field(default=5))], namespace={'add_one': lambda self: self.placeholder_15 + 1})
placeholder_25 = make_dataclass('D', [('x', int, field(default=None)), 'y', str, field(default='a')('z', int, field(default=5))], namespace={'add_one': lambda self: self.placeholder_15 + 1})

@dataclass(frozen=True, slots=True, kw_only=True)
class placeholder_26:
    placeholder_27: dict = field(default_factory=dict)
    placeholder_29: list = field(default_factory=list)

    def placeholder_30(input):
        placeholder_27 = input.read_properties()
        placeholder_29 = []
        while input.expect(';'):
            placeholder_29.append(placeholder_26(placeholder_27=input.read_properties()))
        while input.expect('(', advance=False):
            placeholder_29.append(placeholder_30(input))
        return placeholder_26(placeholder_27=placeholder_27, placeholder_29=placeholder_29)

@dataclass
class placeholder_32:
    placeholder_33: int
    _: KW_ONLY
    placeholder_29: list = field(default_factory=list)

    def placeholder_35(placeholder_36):
        placeholder_36.sort()
        placeholder_37 = []
        for placeholder_38 in placeholder_36:
            placeholder_37.append(placeholder_32(placeholder_38.placeholder_47))
        for placeholder_38 in placeholder_36[1:]:
            placeholder_39 = placeholder_37[placeholder_38.placeholder_48]
            placeholder_40 = placeholder_37[placeholder_38.placeholder_47]
            placeholder_39.placeholder_29.append(placeholder_40)
        return placeholder_37[0]

@dataclass(frozen=True, slots=True, kw_only=True)
class placeholder_26:
    placeholder_27: dict
    placeholder_29: list = field(default_factory=list)

@dataclass(slots=True, kw_only=True)
class placeholder_26:
    placeholder_27: dict = field(default_factory=dict)
    placeholder_29: list = field(default_factory=list)
    placeholder_41: str

@dataclass(frozen=True)
class placeholder_26:
    placeholder_29: list = field(default_factory=list)
    placeholder_27: int

@dataclass(kw_only=True)
class placeholder_26:
    placeholder_27: dict
    placeholder_29: list = field(default_factory=list)

@dataclass(slots=True)
class placeholder_26:
    placeholder_41: str
    placeholder_27: dict = field(default_factory=dict)
    placeholder_29: list = field(default_factory=list)

@dataclass(kw_only=True)
class placeholder_26:
    placeholder_27: dict
    placeholder_29: list = field(default_factory=list)

@dataclass(init=False)
class placeholder_42:
    placeholder_43: List[Any]
    placeholder_44: Mapping[Any, Any]

    def __init__(self, *placeholder_43, **placeholder_44):
        self.placeholder_43 = placeholder_43
        self.placeholder_44 = placeholder_44

@dataclass
class placeholder_32:
    placeholder_33: int
    _: KW_ONLY
    placeholder_29: list = field(default_factory=list)

@dataclass(frozen=True, slots=True, kw_only=True)
class placeholder_26:
    placeholder_27: ...
    placeholder_29: list = field(default_factory=list)

@dataclass(frozen=True, slots=True, kw_only=True)
class placeholder_26:
    placeholder_27: ... = 12
    placeholder_29: list = field(default_factory=list)
    placeholder_41: str

@dataclass
class placeholder_14:
    placeholder_15: float = 0.0
    placeholder_16: ...

@dataclass
class placeholder_10:
    placeholder_11: ...
    placeholder_12: None
    placeholder_13: ...

@dataclass(slots=True)
class placeholder_46:
    placeholder_47: int
    placeholder_48: int = field(kw_only=True)
    placeholder_41: str

    def __lt__(self, placeholder_50):
        return self.placeholder_47 < placeholder_50.placeholder_47

@dataclass(unsafe_hash=True, slots=True)
class placeholder_14:
    placeholder_15: int
    placeholder_16: int

    def __add__(self, placeholder_52):
        return placeholder_14(self.placeholder_15 + placeholder_52.placeholder_15, self.placeholder_16 + placeholder_52.placeholder_16)

    def __eq__(self, placeholder_52):
        if isinstance(placeholder_52, placeholder_14):
            return self.placeholder_15 == placeholder_52.placeholder_15 and self.placeholder_16 == placeholder_52.placeholder_16
        return self.placeholder_15 == placeholder_52[0] and self.placeholder_16 == placeholder_52[1]

@dataclass
class placeholder_14:
    placeholder_15: int
    placeholder_16: int

class placeholder_54:

    def __init__(self, placeholder_55: list[str]):
        self.placeholder_55, self.placeholder_56, self.placeholder_57 = (placeholder_55, len(placeholder_55[0]), len(placeholder_55))

    def search(self, placeholder_59: str) -> tuple[placeholder_14, placeholder_14] | None:
        placeholder_60 = len(placeholder_59) - 1
        for placeholder_16, placeholder_61 in enumerate(self.placeholder_55):
            placeholder_15 = -1
            while (placeholder_15 := placeholder_61.find(placeholder_59[0], placeholder_15 + 1)) >= 0:
                for placeholder_62, placeholder_63 in DIRS:
                    if 0 <= placeholder_15 + placeholder_62 * placeholder_60 < self.placeholder_56 and 0 <= placeholder_16 + placeholder_63 * placeholder_60 < self.placeholder_57:
                        if all((self.placeholder_55[placeholder_16 + placeholder_64 * placeholder_63][placeholder_15 + placeholder_64 * placeholder_62] == placeholder_65 for placeholder_64, placeholder_65 in enumerate(placeholder_59))):
                            return (placeholder_14(placeholder_15, placeholder_16), placeholder_14(placeholder_15 + placeholder_62 * placeholder_60, placeholder_16 + placeholder_63 * placeholder_60))
        return None
