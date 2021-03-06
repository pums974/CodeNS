module mod_c_end
  implicit none
contains
  subroutine c_end(mot,imot,nmot)
!
!***********************************************************************
!
!     ACT
!_A    Realisation de l'action end.
!
!***********************************************************************
!-----parameters figes--------------------------------------------------
!
    use para_fige
    use mod_eend
    use mod_b1_end
    use mod_mpi

    implicit none
    integer          :: imot(nmx),     nmot
!
!-----------------------------------------------------------------------
!
    character(len=32) ::  mot(nmx)
!
    if(rank==0)    call b1_end
    call endmpi
    call eend
!
    return
  end subroutine c_end
end module mod_c_end
