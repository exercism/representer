module ZebraPuzzle

import public ZebraData
import ZebraImplementation



fitParameter : Parameter
            -> (parameterIndex : Fin Len)
            -> Habitant
            -> (neighborhood : UniqueNothing (Vect k Habitant))
            -> UniqueNothing $ Vect (S k) Habitant
fitParameter p pi h@(h' ** _) sh =
  case (isJust (index pi h'), sh) of
       (False, NoNothing sh') => Yes $ replace p h :: sh'
       (True , NoNothing sh') => NoNothing $ h :: sh'
       (True , Yes       sh') => Yes $ h :: sh'
       (False, Yes       sh') => No
       (_    , No           ) => No

foldFit : Parameter
       -> (parameterIndex : Fin Len)
       -> (neighborhood   : Vect l Habitant)
       -> UniqueNothing $ Vect l Habitant
foldFit p pi Nil = NoNothing []
foldFit p pi (h :: hs) = fitParameter p pi h $ foldFit p pi hs

succFit : (Parameter, Fin Len)
       -> Neighborhood
       -> Maybe Neighborhood
       -> Maybe Neighborhood
succFit (p, pIndex) n mn =
  case (foldFit p pIndex (fromMaybe n mn), mn) of
       (Yes n', _      ) => Just n'
       (_     , Just n') => Just n'
       (_     , _      ) => Nothing

||| Correlated:   (Red next Dog)
||| Neighborhood: [Snail Zebra Fox Horse _]   [Blue _ Ivory _ _]
||| Return:       [Snail Zebra Fox Horse Dog] [Blue _ Ivory _ _]
|||
fitCorrelated : List Correlated -> Neighborhood -> Maybe Neighborhood
fitCorrelated Nil _ = Nothing
fitCorrelated ((params, _) :: cs) n =
  let (p, p') := params
   in succFit p n $ succFit p' n $ fitCorrelated cs n



connectParameters : Parameters
                 -> (neighborhood : Vect (S n) Habitant)
                 -> Maybe $ Vect (S n) Habitant
connectParameters _ (_ :: Nil) = Nothing
connectParameters (pi1, pi2) n@(h1 :: h2 :: hs) =
  let (p1, index1) := pi1
      (p2, index2) := pi2
      (h1' ** _  ) := h1
      (h2' ** _  ) := h2
      p1' := index index1 h1'
      p2' := index index2 h2'
      allready := p1' == p1           && p2' == p2
      connect1 := isJust p1' == False && p2  == p2'
      connect2 := p1' == p1           && isJust p2' == False
   in (toMaybe allready n)
  <|> (toMaybe connect1 $ replace p1 h1 :: h2 :: hs)
  <|> (toMaybe connect2 $ h1 :: replace p2 h2 :: hs)
  <|> [| Just h1 :: connectParameters (pi1, pi2) (h2 :: hs) |]

connectCorrelated' : List Correlated
                  -> List Correlated
                  -> Neighborhood
                  -> List (List Correlated, Neighborhood)
connectCorrelated' Nil _ _ = []
connectCorrelated' (c@(params, symParams) :: cs) sc n =
  let cs' := sc ++ cs
   in recConnect cs' params ++ recConnectSym cs' symParams
  where
    recConnect : List Correlated
              -> Parameters
              -> List (List Correlated, Neighborhood)
    recConnect cs' ps =
      case connectParameters ps n of
           Nothing => connectCorrelated' cs (c :: sc) n
           Just nps => (cs', nps) :: connectCorrelated' cs sc nps

    recConnectSym : List Correlated
                 -> Maybe Parameters
                 -> List (List Correlated, Neighborhood)
    recConnectSym cs' sps =
      fromMaybe [] $
        do sps' <- sps
           nsps <- connectParameters sps' n
           Just $ (cs', nsps) :: connectCorrelated' cs sc nsps

|||
||| Correlated:   (a next b or b next a) (x next y) (r next t)
||| Neighborhood: [_ a _ v w] [_ x _ _ z]
||| Return:       correlated [r next t] neighborhood [_ a b v w] [_ x y _ z]
|||               correlated [r next t] neighborhood [b a _ v w] [_ x y _ z]
|||
connectCorrelated : List Correlated
                 -> Neighborhood
                 -> List (List Correlated, Neighborhood)
connectCorrelated c n = connectCorrelated' c [] n



tryUnifyParameters : Parameter -> Parameter -> Habitant -> Maybe Habitant
tryUnifyParameters p p' h =
  case (isJust p, isJust p') of
       (True , False) => Just $ replace p h
       (False, True ) => Just h
       (False, False) => Just h
       (True , True ) => Nothing

foldApp2 : Applicative f => Monad f => (a -> a -> b -> f b) -> Vect n a -> Vect n a -> b -> f b
foldApp2 fn Nil       Nil       z = pure z
foldApp2 fn (x :: xs) (y :: ys) z = fn x y z >>= foldApp2 fn xs ys

plusAssociativeSucc : (n : Nat) -> (m : Nat) -> n + (S m) === nm -> (S n) + m !== nm
plusAssociativeSucc n m p =
  rewrite plusCommutative (S n) m
  in rewrite sym (plusSuccRightSucc m n)
     in rewrite cong S (plusCommutative m n)
        in rewrite plusSuccRightSucc n m
           in p

fitHabitant' : {ln : Nat}
            -> {nl : Nat}
            -> {auto prf : nl + ln === Len}
            -> Habitant
            -> Vect ln Habitant
            -> Vect nl Habitant
            -> List Neighborhood
fitHabitant' {ln = Z    } _  Nil        _  = []
fitHabitant' {ln = S ln'} h1 (h2 :: hs) sh =
  let (h1' ** _) := h1
      (h2' ** _) := h2
      prf' := plusAssociativeSucc nl ln' prf
      rec  := fitHabitant' {prf = prf'} h1 hs (h2 :: sh)
      f    := replace {p = \len => Vect len Habitant} prf
   in case foldApp2 tryUnifyParameters h1' h2' h2 of
           Nothing => rec
           Just h3 => (f $ reverse sh ++ (h3 :: hs)) :: rec

|||
||| Habitant:     [_ a _ _ b]
||| Neighborhood: [u _ _ w _] [r _ s t _] [_ x y _ _]
||| Return:       [u a _ w b] [r _ s t _] [_ x y _ _]
|||               [u _ _ w _] [r a s t b] [_ x y _ _]
|||
fitHabitant : Habitant -> Neighborhood -> List Neighborhood
fitHabitant h n = fitHabitant' h n []



untilJust : (a -> Maybe b) -> List a -> Maybe b
untilJust f Nil       = Nothing
untilJust f (x :: xs) = 
  case f x of
       Nothing => untilJust f xs
       Just  y => Just y

solve : List Habitant -> List Correlated -> Neighborhood -> Maybe Neighborhood
solve Nil Nil n = pure n
solve hs  cs  n = (recCorrelated $ connectCorrelated cs n)
              <|> (recHabitants hs)
              <|> (fitCorrelated cs n >>= solve hs cs)
  where
  recCorrelated : List (List Correlated, Neighborhood) -> Maybe Neighborhood
  recCorrelated Nil = Nothing
  recCorrelated csn = untilJust (\(c', n') => solve hs c' n') csn

  recHabitants : List Habitant -> Maybe Neighborhood
  recHabitants Nil         = Nothing
  recHabitants (h' :: hs') =
    case fitHabitant h' n of
          Nil => Nothing
          ns  => untilJust (solve hs' cs) ns




isNothing : Fin Len ->  Habitant -> Bool
isNothing i (h ** _) = not $ isJust $ index i h

getNationality : Habitant -> Maybe Nationality
getNationality ((_ :: MN n :: _) ** _) = n

findMissing : Fin Len -> Neighborhood -> Maybe Nationality
findMissing i n =
  do habitant    <- find (isNothing i) n
     nationality <- getNationality habitant
     pure nationality

export
solution : Solution
solution =
  fromMaybe solution $
    do neighborhood' <- solve habitants correlated neighborhood
       solution1     <- findMissing 3 neighborhood' 
       solution2     <- findMissing 2 neighborhood'
       pure $ MkSolution solution1 solution2
