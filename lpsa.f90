module mod_lpsa
  implicit none
contains
  subroutine lpsa( &
       v,mu,mut,dist, &
       nxn,nyn,nzn, &
       ncin,ncbd,l, &
       mnpar,fgam,ncyc,tp, &
       ztemp)
!
!***********************************************************************
!
!_DA  DATE_C : janvier 1999-- AUTEUR : Eric Goncalves
!
!     ACT
!_A    Lois de paroi : modele de Spalart Allmaras
!_A    - nut imposee a la paroi
!_A    2 cas : parois adiabatiques et parois isothermes
!_A
!
!_I    ncin       : arg int (ip41      ) ; ind dans un tab tous domaines de la
!_I                                        cell. interieure adjacente a la front
!_I    ncbd       : arg int (ip41      ) ; ind dans un tab tous domaines d'une
!_I                                        cellule frontiere fictive
!_I    nxn        : arg real(ip42      ) ; composante en x du vecteur directeur
!_I                                        normal a une facette frontiere
!_I    nyn        : arg real(ip42      ) ; composante en y du vecteur directeur
!_I                                        normal a une facette frontiere
!_I    nzn        : arg real(ip42      ) ; composante en z du vecteur directeur
!_I                                        normal a une facette frontiere
!_I    v          : arg real(ip11,ip60 ) ; variables a l'instant n+alpha
!_I    u          : arg real(ip11,ip60 ) ; variables a l'instant n
!_I    cl         : com char(mtb       ) ; type de cond lim a appliquer
!_I    mtbx       : com int              ; nbr total de frontieres
!_I    mmb        : com int (mtt       ) ; nombre de facettes d'une frontiere
!_I    mpb        : com int (mtt       ) ; pointeur fin de front precedente
!_I                                        dans tableaux de base des front.
!_I    nba        : com int (mtb       ) ; rang de traitement d'une front
!_I    ndlb       : com int (mtb       ) ; numero dom contenant la frontiere
!_I    mpn        : com int (mtt       ) ; pointeur fin de front precedente
!_I                                        dans tab front a normales stockees
!_I    nbd        : com int              ; nombre de frontieres a traiter
!_I    lbd        : com int (mtt       ) ; numero de front a traiter
!_I    mnpar      : arg real(ip12      ) ; pointeur dans tableaux front normales
!_I                                        stockees du point de rattach normale
!_I    fgam       : arg real(ip42      ) ; fonction d'intermittence pour
!_I                                        transition
!
!
!-----parameters figes--------------------------------------------------
!
    use para_var
    use para_fige
    use maillage
    use boundary
    use mod_lpsa1
    use mod_lpsa2
    implicit none
    integer          ::     l, ldom,   mf,  mfb,mnpar
    integer          ::  ncbd, ncin, ncyc,   no
    double precision ::  dist, fgam,   mu,  mut,  nxn
    double precision ::   nyn,  nzn,   tp,    v,ztemp
!
!-----------------------------------------------------------------------
!
!
    dimension mu(ip12),mut(ip12)
    dimension nxn(ip42),nyn(ip42),nzn(ip42)
    dimension ncin(ip41),ncbd(ip41)
    dimension v(ip11,ip60),dist(ip12)
    dimension mnpar(ip12),fgam(ip42),tp(ip40)
    dimension ztemp(ip11)
!
    nbd=0
    do no=1,mtbx
!c    boucle sur toutes les frontieres
       mfb=nba(no)
       ldom=ndlb(mfb)
       if((cl(mfb)(1:2).eq.'lp').and.(l.eq.ldom)) then
!c      la frontiere est une paroi et appartient au domaine en cours de traitement
          nbd=nbd+1
          lbd(nbd)=mfb
       endif
    enddo
!
    do mf=1,nbd
!c    boucle sur les frontieres a traiter (parois)
       mfb=lbd(mf)
       if(cl(mfb)(1:3).eq.'lp2') then
!c      parois adiabatiques
          call lpsa1( &
               v,mu,mut,dist, &
               nxn,nyn,nzn, &
               ncin,ncbd,mfb,l, &
               mnpar,fgam,ncyc, &
               ztemp)
!
       else if(cl(mfb)(1:3).eq.'lp3') then
!c      parois isothermes
          call lpsa2( &
               v,mu,mut,dist, &
               nxn,nyn,nzn, &
               ncin,ncbd,mfb,l, &
               mnpar,fgam,ncyc,tp, &
               ztemp)
       end if
!
    end do
!
    return
  end subroutine lpsa
end module mod_lpsa
