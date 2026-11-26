def transform(legacy_data):
    salida={}
    
    for k,v in legacy_data.items():
        for i in range (len(v)):
            salida[v[i].upper()]=k
        print(k,v)
    return salida
    pass

