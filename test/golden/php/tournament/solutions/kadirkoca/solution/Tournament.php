<?php

/*
 * By adding type hints and enabling strict type checking, code can become
 * easier to read, self-documenting and reduce the number of potential bugs.
 * By default, type declarations are non-strict, which means they will attempt
 * to change the original type to match the type specified by the
 * type-declaration.
 *
 * In other words, if you pass a string to a function requiring a float,
 * it will attempt to convert the string value to a float.
 *
 * To enable strict mode, a single declare directive must be placed at the top
 * of the file.
 * This means that the strictness of typing is configured on a per-file basis.
 * This directive not only affects the type declarations of parameters, but also
 * a function's return type.
 *
 * For more info review the Concept on strict type checking in the PHP track
 * <link>.
 *
 * To disable strict typing, comment out the directive below.
 */

declare(strict_types=1);

class Tournament
{
    private array $table;
    
    public function __construct()
    {
        $this->table = [];
    }

    public function tally(string $scores): string
    {
        $mask = "%-29s  | %2.s | %2.s | %2.s | %2.s | %2.s";
        $output = sprintf($mask, 'Team', 'MP','W','D','L','P');
        $matches = explode("\n", $scores);
        
        if(empty($scores)){
            return $output;
        }
        foreach($matches  as $match){
            $this->updateTable($match);
        }        
        
        $point  = array_column($this->table, 'P');
        array_multisort($point, SORT_DESC, array_keys($this->table), SORT_ASC, $this->table);
        
        foreach($this->table as $team => $row){
            $output .="\n";
            $output .= sprintf($mask, $team, "{$row['MP']}", "{$row['W']}", "{$row['D']}", "{$row['L']}", "{$row['P']}");
        }
        return $output;
    }

    private function updateTable(string $match): void
    {
        $matchArray = explode(";", $match);
        $team1 = $matchArray[0];
        $team2 = $matchArray[1];
        $result = $matchArray[2];
        $team1Score = 0;
        $team2Score = 0;

        switch($result){
            case 'win':
                $team1Score = 3;
             break;
            case 'loss':
                $team2Score = 3;
             break;
            default:
                $team1Score = 1;
                $team2Score = 1;
        }

        $this->updateScore($team1, $team1Score);
        $this->updateScore($team2, $team2Score);
    }

    private function updateScore(string $team,int $score): void
    {
        $this->table[$team] = $this->table[$team] ?? ['MP'=>0, 'W'=>0, 'D' =>0, 'L'=>0, 'P'=>0];
        $this->table[$team]['MP'] = $this->table[$team]['MP'] + 1;
        $this->table[$team]['W'] = $this->table[$team]['W'] + ($score == 3 ? 1 : 0);
        $this->table[$team]['D'] = $this->table[$team]['D'] + ($score == 1 ? 1 : 0);
        $this->table[$team]['L'] = $this->table[$team]['L'] + ($score == 0 ? 1 : 0);
        $this->table[$team]['P'] = $this->table[$team]['P'] + $score;    
    }
}
