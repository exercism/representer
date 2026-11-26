<?php

declare(strict_types=1);

class Tournament
{
    public string $results = '';
    public array $data = [];

    public function tally(string $scores): string {
        if ($scores) {
            $single_score = explode("\n", $scores);

            foreach($single_score as $one_score) {
                [$local, $visitor, $result] = explode(';', $one_score);
                if ('win' === $result) {
                    $this->team_won($local);
                    $this->team_lost($visitor);
                } else if ('loss' === $result) {
                    $this->team_won($visitor);
                    $this->team_lost($local);
                } else if ('draw' === $result) {
                    echo "draw! \n";
                    $this->teams_draw($local, $visitor);
                }
            }
        }

        usort($this->data, $this->test_one(...));
        return self::print_results();
    }

    private function match_played(string $team): void {
        if ( in_array($team, array_keys($this->data)) ) {
            $this->data[$team]['matchs_played'] += 1;
            return;
        }

        $this->data[$team] = [
            'team_name' => $team,
            'matchs_played' => 1,
            'win' => 0,
            'draw' => 0,
            'lost' => 0,
            'points' => 0
        ];
    }

    private function team_won($team): void {
        $this->match_played($team);
        $this->data[$team]['win'] += 1;
        $this->data[$team]['points'] += 3;
    }

    private function team_lost($team): void {
        $this->match_played($team);
        $this->data[$team]['lost'] += 1;
    }

    private function teams_draw($local, $visitor): void {
        $this->match_played($local);
        $this->match_played($visitor);
        $this->data[$local]['draw'] += 1;
        $this->data[$local]['points'] += 1;
        
        $this->data[$visitor]['draw'] += 1;
        $this->data[$visitor]['points'] += 1;
    }

    private function print_results(): string {
        $results = sprintf("%-30s | MP |  W |  D |  L |  P", 'Team');

        foreach ($this->data as $team => $result) {
            $results .= sprintf("\n%-30s | %2s | %2s | %2s | %2s | %2s", $result['team_name'], $result['matchs_played'], $result['win'], $result['draw'], $result['lost'], $result['points']);
        }
        
        return $results;
    }
    
    private function test_one($a, $b): int {
        if ($a['points'] === $b['points']) {
            return $a['team_name'] <=> $b['team_name'];
        }
        return $b['points'] - $a['points'];
    }
}
