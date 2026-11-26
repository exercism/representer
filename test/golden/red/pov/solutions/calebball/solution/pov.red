Red [
	description: {"POV" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

path-from-root: function [
	tree
	target
] [
	case [
		tree/label = target [reduce [tree]]
		none? tree/children [none]
		'else [
			result: none
			foreach c tree/children [
				subpath: path-from-root c target
				if not none? subpath [
					insert subpath tree
					result: subpath
					break
				]
			]
			result
		]
	]
]

from-pov: function [
	tree
	from
] [
	path: path-from-root tree from
	if none? path [return none]

	while [1 < length? path] [
		if none? path/2/children [path/2/children: copy []]

		alter path/1/children path/2
		alter path/2/children path/1

		if empty? path/1/children [remove/key path/1 'children]

		path: next path
	]

	first path
]

path-to: function [
	from
	to
	tree
] [
	tree: from-pov tree from
	if none? tree [return none]

	path: path-from-root tree to
	if none? path [return none]

	collect [
		foreach node path-from-root tree to [
			keep node/label
		]
	]
]

