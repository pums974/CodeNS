module mod_c_dffw
  use mod_tcmd_dffw
  implicit none
contains
  subroutine c_dffw(mot,imot,nmot)
!
!***********************************************************************
!
!     ACT
!_A    Realisation de l'action dffw.
!
!     INP
!_I    kimp       : com int              ; niveau de sortie sur unite logi imp
!_I    klomg      : com int              ; cle pour rotation du repere relatif
!
!     I/O
!_/    omg        : com real             ; vitesse rotation du repere relatif
!
!-----parameters figes--------------------------------------------------
!
    use para_fige
    use sortiefichier
    use mod_dffw
    use mod_b1_dffw
    use mod_mpi
    implicit none
    integer          :: imot(nmx),     nmot
!
!-----------------------------------------------------------------------
!
    character(len=32) ::  mot(nmx)
!
    call tcmd_dffw(mot,imot,nmot)
!
    if (kimp.ge.1) then
       if(rank==0) call b1_dffw
       call barrier
    endif
!
    call dffw
!
    return
  end subroutine c_dffw
end module mod_c_dffw
