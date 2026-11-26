module DiffieHellman

let privateKey =
    let rand = System.Random()

    fun (primeP: bigint) ->
        let buf = primeP.GetByteCount() |> Array.zeroCreate 
        fun _ -> rand.NextBytes buf; buf |> bigint |> abs
        |> Seq.initInfinite 
        |> Seq.find (fun n -> n > 1I && n < primeP)

let publicKey 
    (primeP: bigint) (primeG: bigint) (privateKey: bigint) =
        pown primeG (int privateKey) % primeP

let secret
    (primeP: bigint)
    (publicKey: bigint) 
    (privateKey: bigint) =
        pown publicKey (int privateKey) % primeP