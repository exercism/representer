package erratum

func Use(o ResourceOpener, input string) (err error) {
	var res Resource

	// Keep trying as long as error is TransientError or nil.
	for res, err = o(); err != nil; res, err = o() {
		if _, ok := err.(TransientError); !ok {
			return err
		}
	}

	// Make sure resource is closed.
	defer res.Close()

	// Recover from Frob panic.
	defer func() {
		if r := recover(); r != nil {
			switch e := r.(type) {
			case FrobError:
				res.Defrob(e.defrobTag)
				err = e
			case error:
				err = e
			}
		}
	}()

	res.Frob(input)
	return err
}
