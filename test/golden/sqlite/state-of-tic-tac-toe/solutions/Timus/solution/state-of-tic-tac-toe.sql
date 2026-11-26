UPDATE "state-of-tic-tac-toe" SET (result, error) = (
	WITH chars(i, r, c) AS (  -- disect the board into chars, identify the rows
		SELECT 2, 0, substr(board, 1, 1)
	    UNION
    	SELECT i + 1, iif((i - 1) % 4, r + 1, r), substr(board, i, 1)
    	FROM chars WHERE i <= length(board)
	),
	xos(r, c, XO) AS (  -- extract the Xs and Os, identify the columms
		SELECT CAST(r / 3 AS INT), r % 3, c FROM chars WHERE c IN ('X', 'O')
      	UNION VALUES (NULL, NULL, 'X'), (NULL, NULL, 'O')  -- in case no X or O is present
	),
	XO_stats(XO, turns, win) AS (  -- count occurences and check win conditions
        SELECT XO,
               COUNT(r),                                                  -- number of turns
               sum(r = 0) = 3 OR sum(r = 1) = 3 OR sum(r = 2) = 3         -- win in rows?
                   OR sum(c = 0) = 3 OR sum(c = 1) = 3 OR sum(c = 2) = 3  -- win in columns?
                   OR sum(r - c = 0) = 3 OR sum(r + c = 2) = 3            -- win in diagonals?
        FROM xos GROUP BY XO
	),
  	stats_row(Xs, Os, X_wins, O_wins) AS (  -- put stats into one row
      	SELECT x.turns, o.turns, x.win, o.win
    	FROM (SELECT * FROM XO_stats WHERE XO = 'X') x,
             (SELECT * FROM XO_stats WHERE XO = 'O') o
    ),
  	error(error)  AS (  -- identify errors
    	SELECT CASE
        	WHEN Os = Xs + 1 THEN 'Wrong turn order: O started'
            WHEN Xs = Os + 2 THEN 'Wrong turn order: X went twice'
            WHEN X_wins AND O_wins THEN 'Impossible board: game should have ended after the game was won'
      	END FROM stats_row
    ),
  	result(result) AS (  -- identify results if no error occured
      	SELECT CASE
            WHEN error IS NULL THEN CASE
      		    WHEN X_wins OR O_wins THEN 'win'
                WHEN Xs + Os = 9 THEN 'draw'
      		    ELSE 'ongoing'
            END
        END FROM stats_row, error
    )
  	SELECT result, error FROM result, error
)