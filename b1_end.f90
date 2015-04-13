module mod_b1_end
  implicit none
contains
  subroutine b1_end
!
!***********************************************************************
!
!     ACT
!_A    Sorties dans le fichier fimp pour la commande 'end'.
!
!***********************************************************************
!
    use sortiefichier
    implicit none
!
!-----------------------------------------------------------------------
!
    character(len=1316) :: form
!$OMP MASTER
!
    form='(/,2x,''essai termine'',/' &
         //'2x,''-------------'',)'
    write(imp,form)
!
!$OMP END MASTER
    return
  end subroutine b1_end
end module mod_b1_end
