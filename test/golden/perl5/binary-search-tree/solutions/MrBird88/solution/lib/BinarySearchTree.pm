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

sub add ( $self, $val, $node = $self->root ) {
  if ( $node->data > $val ) {
    return add( $self, $val, $node->left ) if defined $node->left;
    $node->left( BinarySearchTree::Node->new( data => $val ) );
  } else {
    return add( $self, $val, $node->right ) if defined $node->right;
    $node->right( BinarySearchTree::Node->new( data => $val ) );
  }
}

sub sort ( $self, $node = $self->root ) {
  return [] unless defined $node;
  return [
    BinarySearchTree->sort( $node->left )->@*,
    $node->data,
    BinarySearchTree->sort( $node->right )->@*,
  ];
}
