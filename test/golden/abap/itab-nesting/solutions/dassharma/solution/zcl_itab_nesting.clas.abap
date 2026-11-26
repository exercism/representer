CLASS zcl_itab_nesting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF artists_type,
             artist_id   TYPE string,
             artist_name TYPE string,
           END OF artists_type.
    TYPES artists TYPE STANDARD TABLE OF artists_type WITH KEY artist_id.
    TYPES: BEGIN OF albums_type,
             artist_id  TYPE string,
             album_id   TYPE string,
             album_name TYPE string,
           END OF albums_type.
    TYPES albums TYPE STANDARD TABLE OF albums_type WITH KEY artist_id album_id.
    TYPES: BEGIN OF songs_type,
             artist_id TYPE string,
             album_id  TYPE string,
             song_id   TYPE string,
             song_name TYPE string,
           END OF songs_type.
    TYPES songs TYPE STANDARD TABLE OF songs_type WITH KEY artist_id album_id song_id.


    TYPES: BEGIN OF song_nested_type,
             song_id   TYPE string,
             song_name TYPE string,
           END OF song_nested_type.
    TYPES: BEGIN OF album_song_nested_type,
             album_id   TYPE string,
             album_name TYPE string,
             songs      TYPE STANDARD TABLE OF song_nested_type WITH KEY song_id,
           END OF album_song_nested_type.
    TYPES: BEGIN OF artist_album_nested_type,
             artist_id   TYPE string,
             artist_name TYPE string,
             albums      TYPE STANDARD TABLE OF album_song_nested_type WITH KEY album_id,
           END OF artist_album_nested_type.
    TYPES nested_data TYPE STANDARD TABLE OF artist_album_nested_type WITH KEY artist_id.

    METHODS perform_nesting
      IMPORTING
        artists            TYPE artists
        albums             TYPE albums
        songs              TYPE songs
      RETURNING
        VALUE(nested_data) TYPE nested_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_itab_nesting IMPLEMENTATION.

  METHOD perform_nesting.
    DATA:
      nested_songs  TYPE STANDARD TABLE OF song_nested_type WITH KEY song_id,
      nested_albums TYPE STANDARD TABLE OF album_song_nested_type WITH KEY album_id.

    IF songs IS NOT INITIAL.
      LOOP AT songs ASSIGNING FIELD-SYMBOL(<fs_song>).
        READ TABLE nested_data ASSIGNING FIELD-SYMBOL(<fs_artist_album>) WITH KEY artist_id = <fs_song>-artist_id.
        IF sy-subrc = 0.
          READ TABLE <fs_artist_album>-albums ASSIGNING FIELD-SYMBOL(<fs_album_song>) WITH KEY album_id = <fs_song>-album_id.
          IF sy-subrc = 0.
            READ TABLE <fs_album_song>-songs ASSIGNING FIELD-SYMBOL(<fs_song_song>) WITH KEY song_id = <fs_song>-song_id.
            IF sy-subrc <> 0.
              APPEND VALUE #( song_id   = <fs_song>-song_id
                              song_name = <fs_song>-song_name  ) TO <fs_album_song>-songs.
            ENDIF.
          ELSE.
            APPEND VALUE #( album_id   = <fs_song>-album_id
                            album_name = VALUE #( albums[ album_id = <fs_song>-album_id artist_id = <fs_song>-artist_id  ]-album_name OPTIONAL )
                            songs      = VALUE #( ( song_id = <fs_song>-song_id
                                                    song_name = <fs_song>-song_name  ) ) ) TO <fs_artist_album>-albums.
          ENDIF.
        ELSE.
          "  Insert new data
          APPEND VALUE #( artist_id   = <fs_song>-artist_id
                          artist_name = VALUE #( artists[ artist_id   = <fs_song>-artist_id ]-artist_name OPTIONAL )
                          albums      = VALUE #( ( album_id   = <fs_song>-album_id
                                                   album_name = VALUE #( albums[ album_id = <fs_song>-album_id artist_id = <fs_song>-artist_id ]-album_name OPTIONAL )
                                                   songs      = VALUE #( ( song_id = <fs_song>-song_id
                                                                           song_name = <fs_song>-song_name  ) ) ) ) ) TO nested_data.
        ENDIF.
      ENDLOOP.
    ELSEIF albums IS NOT INITIAL.
      LOOP AT albums ASSIGNING FIELD-SYMBOL(<fs_album>).
        READ TABLE nested_data ASSIGNING <fs_artist_album> WITH KEY artist_id = <fs_album>-artist_id.
        IF sy-subrc = 0.
          READ TABLE <fs_artist_album>-albums ASSIGNING <fs_album_song> WITH KEY album_id = <fs_album>-album_id.
          IF sy-subrc <> 0.
            APPEND VALUE #( album_id   = <fs_album>-album_id
                            album_name = VALUE #( albums[ album_id = <fs_album>-album_id artist_id = <fs_album>-artist_id  ]-album_name OPTIONAL ) ) TO <fs_artist_album>-albums.
          ENDIF.
        ELSE.
          "  Insert new data
          APPEND VALUE #( artist_id   = <fs_song>-artist_id
                          artist_name = VALUE #( artists[ artist_id   = <fs_album>-artist_id ]-artist_name OPTIONAL )
                          albums      = VALUE #( ( album_id   = <fs_album>-album_id
                                                   album_name = VALUE #( albums[ album_id = <fs_album>-album_id artist_id = <fs_album>-artist_id ]-album_name OPTIONAL ) ) ) ) TO nested_data.
        ENDIF.
      ENDLOOP.
    ELSEIF artists IS NOT INITIAL.
      LOOP AT artists ASSIGNING FIELD-SYMBOL(<fs_artist>).
          "  Insert new data
          APPEND VALUE #( artist_id   = <fs_artist>-artist_id
                          artist_name = VALUE #( artists[ artist_id   = <fs_artist>-artist_id ]-artist_name OPTIONAL ) ) TO nested_data.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
