module LensPerson

open System
open Aether.Operators

type DateTime with
    static member month_ = 
        (fun (d: DateTime) -> d.Month),
        (fun m (d: DateTime) -> DateTime(d.Year, m, d.Day))

type FullName = { name: string; surName: string } with
    static member name_ = 
        (fun n -> n.name), (fun n f -> { f with name = n })
    static member surName_ = 
        (fun n -> n.surName),
        (fun s f -> { f with surName = s })

type Address =
    { street: string; houseNumber: int
      place: string; country: string }
    static member street_ = 
        (fun a -> a.street), 
        (fun s a -> { a with street = s })
    static member houseNumber_ = 
        (fun a -> a.houseNumber),
        (fun h a -> { a with houseNumber = h })
    static member place_ = 
        (fun a -> a.place),
        (fun p a -> { a with place = p })
    static member country_ = 
        (fun a -> a.country),
        (fun c a -> { a with street = c })

type Birth = { at: Address; on: DateTime } with
    static member at_ = 
        (fun b -> b.at), (fun a b -> { b with at = a })
    static member on_ = 
        (fun b -> b.on), (fun o b -> { b with on = o })

type Person = 
    { name: FullName; born: Birth; address: Address }
    static member name_ = 
        (fun p -> p.name), 
        (fun n p -> { p with Person.name = n })
    static member born_ = 
        (fun p -> p.born), (fun b p -> { p with born = b })
    static member address_ = 
        (fun p -> p.address),
        (fun a p -> { p with address = a })

let bornAtStreet =
    Person.born_ >-> Birth.at_ >-> Address.street_

let currentStreet = Person.address_ >-> Address.street_

let bornOn = Person.born_ >-> Birth.on_

let birthMonth = 
    Person.born_ >-> Birth.on_ >-> DateTime.month_
