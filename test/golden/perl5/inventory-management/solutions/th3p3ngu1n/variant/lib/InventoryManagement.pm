package InventoryManagement;

use v5.43;

sub create_inventory ($items) {
    return add_items({}, $items);
}

sub add_items ( $inventory, $items ) {
    foreach my $item (@$items) {
        $inventory->{$item}++;
    }
    return $inventory;
}

sub remove_items ( $inventory, $items ) {
    foreach my $item (@$items) {
        if ($inventory->{$item}) {
            $inventory->{$item}--;
        }
    }
    return $inventory;
}

sub delete_item ( $inventory, $item ) {
    delete $inventory->{$item};
    return $inventory;
}

1;
