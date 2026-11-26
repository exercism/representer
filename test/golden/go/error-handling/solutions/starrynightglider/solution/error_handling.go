package erratum

func Use(o ResourceOpener, input string) (err error) {
	var resource Resource
	for resource, err = o(); err != nil; resource, err = o() {
		if _, ok := err.(TransientError); !ok {
			return err
		}
	}
	defer resource.Close()
	defer func() {
		if r := recover(); r != nil {
			switch e := r.(type) {
			case FrobError:
				resource.Defrob(e.defrobTag)
				err = e
			case error:
				err = e
			}
		}
	}()
	resource.Frob(input)
	return err
}
