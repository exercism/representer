interface inputPointSystemType {
    [key: string]: string[]
}

interface outputPointSystemType {
    [key: string]: number
}

export function transform(pointSystem: inputPointSystemType): outputPointSystemType {
    let obj: outputPointSystemType = {}

    Object.keys(pointSystem).forEach(key => {
        const values = pointSystem[key]

        values.forEach(value => {
            obj[value.toUpperCase()] = Number(key)
        })
    })
  
    return obj
}