package InventoryManagement;

use v5.38;

sub create_inventory ($items) {
    my %inventory;
    $inventory{$_}++ for (@$items);
    return \%inventory;
}

sub add_items ( $inventory, $items ) {
    $$inventory{$_}++ for (@$items);
    return $inventory;
}

sub remove_items ( $inventory, $items ) {
    $$inventory{$_}-- or $$inventory{$_} = 0 for (@$items);
    return $inventory;
}

sub delete_item ( $inventory, $item ) {
    delete $$inventory{$item};
    return $inventory;
}
