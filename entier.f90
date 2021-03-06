module mod_entier
  implicit none
contains
  subroutine entier(mot,imot,i,kerr)
    implicit none
    integer          ::    i,imot,kerr
!
!***********************************************************************
!
!     ACT
!_A    Lecture d'un entier dans une variable character.
!
!***********************************************************************
!
    character(len=32) ::  mot
    character(len=4 ) :: formatm
    character(len=1 ) :: longm
!
    write(longm,'(i1)') imot
    formatm='(i'//longm//')'
    kerr=0
    read(mot,formatm,err=100) i
    kerr=1
100 continue
!
    return
  end subroutine entier
end module mod_entier
