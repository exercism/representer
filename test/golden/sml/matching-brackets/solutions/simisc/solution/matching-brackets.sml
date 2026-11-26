val isBalanced =
  let
    fun aux xs cs =
      case (cs, xs) of
        ([], [])            => true
      | ([], _)             => false
      | (#"}"::cs', [])     => false
      | (#"]"::cs', [])     => false
      | (#")"::cs', [])     => false
      | (#"}"::cs', x::xs') => x = #"{" andalso aux xs' cs'
      | (#"]"::cs', x::xs') => x = #"[" andalso aux xs' cs'
      | (#")"::cs', x::xs') => x = #"(" andalso aux xs' cs'
      | (#"{"::cs', _)      => aux (#"{"::xs) cs'
      | (#"["::cs', _)      => aux (#"["::xs) cs'
      | (#"("::cs', _)      => aux (#"("::xs) cs'
      | (_::cs', _)         => aux xs cs'
  in aux [] o String.explode
  end
