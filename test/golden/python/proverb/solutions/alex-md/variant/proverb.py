def proverb(*A,qualifier=None):
	C=qualifier
	if not A:return[]
	if C:D=f"And all for the want of a {C} {A[0]}."
	else:D=f"And all for the want of a {A[0]}."
	B=[]
	for E in range(len(A)+1):B.append(f"For want of a {A[E]} the {A[E+1]} was lost.")
	B.append(D);return B