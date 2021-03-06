module mod_c_intn
  implicit none
contains
  subroutine c_intn(mot,imot,nmot)
!
!***********************************************************************
!
!     ACT
!_A    Realisation de l'action intn.
!
!***********************************************************************
!-----parameters figes--------------------------------------------------
!
    use para_fige
    use sortiefichier
    use mod_b1_intn
    use mod_tcmd_intn
    use mod_mpi
    implicit none
    integer          :: imot(nmx),     nmot
!
!-----------------------------------------------------------------------
!
    character(len=32) ::  mot(nmx)
!
!
    call tcmd_intn(mot,imot,nmot)
!
    if(kimp.ge.1) then
       if (rank==0) call b1_intn
       call barrier
    endif
!
    return
  end subroutine c_intn
end module mod_c_intn
