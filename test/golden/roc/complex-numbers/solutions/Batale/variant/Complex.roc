Complex := { real : F64, imag : F64 }.{
	# # The user can write plus(z1, z2), z1.plus(z2), or simply z1 + z2
	plus : Complex, Complex -> Complex
	plus = |z1, z2| {real: z1.real + z2.real, imag: z1.imag + z2.imag}

	# # The user can write minus(z1, z2), z1.minus(z2), or simply z1 - z2
	minus : Complex, Complex -> Complex
	minus = |z1, z2| {real: z1.real - z2.real, imag: z1.imag - z2.imag}

	# # The user can write times(z1, z2), z1.times(z2), or simply z1 * z2
	times : Complex, Complex -> Complex
	times = |z1, z2| {
		real: z1.real * z2.real - z1.imag * z2.imag,
        imag: z1.imag * z2.real + z1.real * z2.imag
	}

	# # The user can write div_by(z1, z2), z1.div_by(z2), or simply z1 / z2
	div_by : Complex, Complex -> Complex
	div_by = |z1, z2| {
		real: (z1.real * z2.real + z1.imag * z2.imag) / (z2.real.pow(2) + z2.imag.pow(2)),
        imag: (z1.imag * z2.real - z1.real / z2.imag) / (z2.real.pow(2) + z2.imag.pow(2))
	}

	conjugate : Complex -> Complex
	conjugate = |z| {..z, imag: -z.imag}

	abs : Complex -> F64
	abs = |z| {z.real.pow(2) + z.imag.pow(2)}.sqrt()

	exp : Complex -> Complex
	exp = |z| {
		real: F64.e.pow(z.real) * F64.cos(z.imag),
        imag: F64.e.pow(z.real) * F64.sin(z.imag)
	}
}
