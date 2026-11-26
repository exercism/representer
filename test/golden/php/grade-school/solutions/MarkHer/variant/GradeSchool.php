<?php

declare(strict_types=2);

class GradeSchool
{
    public $students = array();

    public function add(string $name, int $grade): bool
    {
        if(!isset($this->students[$grade])){
           $this->students[$grade]=array();
        }
        foreach(array_keys($this->students)as $sg){
            if(in_array($name,$this->students[$sg])){
                return false;
        }      
        array_push($this->students[$grade],$name);
        return true;

        }
    }

    public function grade(int $grade): array
    {
        if( empty($this->students[$grade])){ return [];}
        sort($this->students[$grade]);
        return $this->students[$grade];
    }

    public function roster(): array
    {
        $all=array();
        ksort($this->students);
        foreach($this->students as $grade){
            sort($grade);
            foreach($grade as $student){
                array_push($all,$student);
            }       
        }

        return $all;
    }
}
