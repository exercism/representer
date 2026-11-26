
# 1) accum = некоторая функция, которую надо применить к элементам
# 2) this = данные, к которым надо применить функцию accum
# 3) for = цикл по всем элементам this, внутри выполняется accum(value)

Array::accumulate = (accum) ->
    accum(value) for value in this
