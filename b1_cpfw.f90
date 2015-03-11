module mod_b1_cpfw
implicit none
contains
      subroutine b1_cpfw
!
!***********************************************************************
!
!     ACT
!_A    Sorties dans le fichier fimp pour la commande 'cpfw'.
!
!     INP
!_I    imp        : com int     ; unite logiq, sorties de controle
!
!***********************************************************************
!
      use sortiefichier
implicit none
!
!-----------------------------------------------------------------------
!
      character(len=1316) :: form
!
       form='(/,2x,''realisation du calcul'',/' &
             //'2x,''---------------------'')'
      write(imp,form)
!
      return
      end subroutine
end module
