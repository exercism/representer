module raindrops
  implicit none
contains

  function convert(i) result(sound)
    integer :: i
    character(len=15) :: sound
    character(len=5) :: Pling = 'Pling', Plang = 'Plang', Plong = 'Plong'

    sound = ''

    if (mod(i, 3) == 0) then
      sound = trim(sound) // Pling
    end if

    if (mod(i, 5) == 0) then
      sound = trim(sound) // Plang
    end if

    if (mod(i, 7) == 0) then
      sound = trim(sound) // Plong
    end if

    if (sound == '') then
      write(sound, '(I0)') i
    end if
  end function

end module raindrops
