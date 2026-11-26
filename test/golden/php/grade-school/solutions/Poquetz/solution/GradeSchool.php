<?php
declare(strict_types=1);

final class GradeSchool
{
    /** array<string, int> */
    private array $students = [];
    public function add(string $name, int $grade): bool
    {
        if (isset($this->students[$name])) {
            return false;
        }
        
        $this->students[$name] = $grade;
        return true;
    }
    public function roster(): array
    {
        $sorted = [];
        foreach ($this->students as $name => $grade) {
            $sorted[] = [$grade, $name];
        }
        
        usort($sorted, static fn ($a, $b) => $a <=> $b);
        return array_map(static fn ($item) => $item[1], $sorted);
    }
    /** @return string[] */
    public function grade(int $grade): array
    {
        $students_in_grade = [];
        foreach ($this->students as $name => $student_grade) {
            if ($grade === $student_grade) {
                $students_in_grade[] = $name;
            }
        }
        sort($students_in_grade);
        return $students_in_grade;
    }
}
