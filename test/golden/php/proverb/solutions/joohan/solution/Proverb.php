<?php declare(strict_types=1);

final class Proverb
{
    /**
     * @param string[] $pieces
     * @return string[]
     */
    public function recite(array $pieces): array
    {
        $size = count($pieces);
        
        if ($size === 0) {
            return [];
        }
        
        $result = [];
        
        for ($i = 0; $i < $size - 1; $i++) {
            $result[] = sprintf('For want of a %s the %s was lost.', $pieces[$i], $pieces[$i+1]);
        }

        $result[] = sprintf('And all for the want of a %s.', $pieces[0]);
        
        return $result;
    }
}
