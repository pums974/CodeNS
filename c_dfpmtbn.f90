module mod_c_dfpmtbn
  implicit none
contains
  subroutine c_dfpmtbn(mot,imot,nmot)
!
!***********************************************************************
!
!     ACT
!_A    Realisation de l'action dfpmtbn.
!
!     INP
!_I    kimp       : com int              ; niveau de sortie sur unite logi imp
!_I    icytur0    : com int              ; nbr de cycl en deb de calcul au cours
!_I                                        desquelles mut n'est pas mis a jour
!_I    ncyturb    : com int              ; freq en it de mise a jour de mut
!
!***********************************************************************
!-----parameters figes--------------------------------------------------
!
    use para_fige
    use sortiefichier
    use modeleturb
    use mod_tcmd_dfpmtbn
    use mod_b1_dfpmtbn
    use mod_mpi
    implicit none
    integer          :: imot(nmx),     nmot
!
!-----------------------------------------------------------------------
!
    character(len=32) ::  mot(nmx)
!
    call tcmd_dfpmtbn(mot,imot,nmot)
!
    if(kimp.ge.1) then
       if (rank==0) call b1_dfpmtbn
    endif
!
    return
  end subroutine c_dfpmtbn
end module mod_c_dfpmtbn
