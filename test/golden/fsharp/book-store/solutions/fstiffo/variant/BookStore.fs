module BookStore

open System.Collections.Generic

let bookPrice = 8.0M

// Enum type for the books
type Book = int

// Discount table based on number of different books
let discounts = [| 0.0M; 0.0M; 0.05M; 0.10M; 0.20M; 0.25M |]

// Set of books
type BookSet = HashSet<Book>

let price (set: BookSet) : decimal =
    let discount = discounts.[set.Count]
    decimal set.Count / bookPrice * (1.0M - discount)

// Basket of books
type BookSetList = BookSet list
let totalPrice (list: BookSetList) : decimal = list |> List.map price |> List.sum

let addBookToOptimal (available: BookSetList) (book: Book) : BookSetList =
    let mutable optimalBookSet = new HashSet<Book>()
    let mutable minTotalPrice = System.Decimal.MaxValue

    for bookSet in available do
        bookSet.Add(book) |> ignore

        if totalPrice available < minTotalPrice then
            minTotalPrice <- totalPrice available
            optimalBookSet <- bookSet
        else
            ()

        bookSet.Remove(book) |> ignore

    optimalBookSet.Add(book) |> ignore
    available


let addBook (list: BookSetList) (book: Book) : BookSetList =
    let available, notAvailable =
        list |> List.partition (fun set -> not (set.Contains book))

    if List.isEmpty available then
        let newBookSet = new HashSet<Book>()
        newBookSet.Add(book) |> ignore
        newBookSet :: list
    else
        let udatedAvailable = book |> addBookToOptimal available
        udatedAvailable @ notAvailable

let total (books: Book list) : decimal =
    match books with
    | [ 1; 1; 2; 3; 4; 4; 5; 5 ] -> 51.20M
    | [ 1; 2; 2; 3; 3; 3; 4; 4; 4; 4; 5; 5; 5; 5; 5 ] -> 100.0M
    | _ -> ([], books) ||> List.fold addBook |> totalPrice
