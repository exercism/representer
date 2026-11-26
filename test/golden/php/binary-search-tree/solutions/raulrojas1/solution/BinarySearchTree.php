<?php
declare(strict_types=1);

class BinarySearchTree
{
    public ?BinarySearchTree $left = null;
    public ?BinarySearchTree $right = null;

    public function __construct(public int $data) { }
    
    public function insert(int $data) : void
    {
        if($data > $this->data) {
            $this->insertRight($data);
        } else {
            $this->insertLeft($data);
        }
    }

    public function getSortedData(): array
    {
        $rightArray = isset($this->right) 
            ? $this->right->getSortedData() 
            : [];
        $leftArray = isset($this->left) 
            ? $this->left->getSortedData() 
            : [];
        return array_merge($leftArray, [$this->data], $rightArray);
    }
    
    public function insertRight(int $data): void
    {
        if(!$this->right){
            $this->right = new BinarySearchTree($data);
            return;
        }
        $this->right->insert($data);
    }

    public function insertLeft(int $data): void
    {
        if(!$this->left){
            $this->left = new BinarySearchTree($data);
            return;
        }
        $this->left->insert($data);
    }
}
