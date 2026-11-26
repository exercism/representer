proc reverse*(toBeReverse: string): string =
    for i in countdown(toBeReverse.len()-1,0):
        result.add(toBeReverse[i])

echo reverse("coba")
