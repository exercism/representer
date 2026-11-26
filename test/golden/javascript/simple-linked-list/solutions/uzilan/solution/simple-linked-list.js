export class Element {
	constructor(value, next = null) {
		this.val = value
		this.ne = next
	}

	get value() {
		return this.val
	}

	get next() {
		return this.ne
	}
}

export class List {
	constructor(list) {
		this.first = null
		if (!list) return

		for (const element of list) {
			this.first = new Element(element, this.first)
		}
	}

	add(nextValue) {
		this.first = new Element(nextValue.val, this.first)
	}

	get length() {
		let length = 0
		this.#forEach(() => length++)
		return length
	}

	get head() {
		return this.first ?? null
	}

	toArray() {
		const arr = []
		this.#forEach(curr => arr.push(curr.val))
		return arr
	}

	reverse() {
		return new List(this.toArray())
	}

	#forEach(callback) {
		let curr = this.first
		while (curr !== null) {
			callback(curr)
			curr = curr.next
		}
	}
}
