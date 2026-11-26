% Predicado principal que inicia el cálculo.
% Empezamos asumiendo que la raíz podría ser el mismo número (nuestra primera "suposición").
square_root(Radicand, Root) :-
    Radicand > 0,
    heron(Radicand, Radicand, Root).

% Caso recursivo: Refinamos la suposición usando el Método de Herón.
heron(Radicand, Guess, Root) :-
    % Calculamos la siguiente aproximación matemática
    Next is (Guess + Radicand div Guess) div 2,
    
    % Si la siguiente aproximación es mayor o igual a la actual, 
    % significa que hemos tocado fondo en los números enteros y encontramos la raíz.
    (   Next > Guess
    ->  Root = Guess
    
    % Si la siguiente aproximación es menor, seguimos refinando (llamada recursiva).
    ;   heron(Radicand, Next, Root)
    ).