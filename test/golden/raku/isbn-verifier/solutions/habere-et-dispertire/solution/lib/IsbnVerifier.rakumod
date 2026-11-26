grammar ISBN {

    rule TOP { <digit> ** 9 [ <digit> | X ] }
    token ws { <:Dash_Punctuation> ?        }

}

class ISBN::Verify {

    method TOP ( $/ ) {
        make .sum %% 11 with 1..10 Z× $<digit>.Slip, 10
    }
 
}

sub is-isbn10 ( $barcode ) is export {

    ISBN.parse( $barcode, actions => ISBN::Verify )
        .made
        .so

}