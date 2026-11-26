package BinarySearchTree;

use v5.38;
use Moo;

package BinarySearchTree::Node {
    use Moo;

    has data => (
        is => 'ro',
    );
    has [qw<left right>] => (
        is => 'rw',
    );
};

has root => (
    is => 'rw',
);

sub add ($self, $val) {
    my $cur = $self->root;
    my $prev = $cur;
    while (defined $cur){
        $prev = $cur;
        if($val > $cur->data){
            $cur = $cur->right;
        }else{
            $cur = $cur->left;
        }
    }
    if($val > $prev->data){
        $prev->right(BinarySearchTree::Node->new(data=>$val));
    }else{
        $prev->left(BinarySearchTree::Node->new(data=>$val));
    }
}

sub _to_array($ar, $node){
    if(not defined $node){
        return;
    }
    _to_array($ar, $node->left);
    push($ar->@*, $node->data);
    _to_array($ar, $node->right);
}

sub sort ($self) {
    my @res;
    _to_array(\@res, $self->root);
    return \@res;
}
