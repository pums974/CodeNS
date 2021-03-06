module mod_cllparoi2
  implicit none
contains
  subroutine cllparoi2( &
       img,ncyc, &
       v, &
       nxn,nyn,nzn, &
       ncin,ncbd, &
       toxx,toxy,toxz,toyy,toyz,tozz, &
       qcx,qcy,qcz, &
       ztemp,utau,topz)
!
!***********************************************************************
!
!_DA  DATE_C : avril 1999 - AUTEUR : Eric Goncalves / DMAE
!
!     ACT
!_A    Application de la condition aux limites lois de paroi.
!_A    Approche de Smith.
!
!     VARIABLE
!_I    ncin       : arg int (ip41      ) ; ind dans un tab tous domaines de la
!_I                                        cell. interieure adjacente a la front
!_I    ncbd       : arg int (ip41      ) ; ind dans un tab tous domaines d'une
!_I                                        cellule frontiere fictive
!_I    mnr        : arg int (ip44      ) ; ind dans un tab tous domaines d'une
!_I                                        cellule recouvrante
!_I    nxn        : arg real(ip42      ) ; composante en x du vecteur directeur
!_I                                        normal a une facette frontiere
!_I    nyn        : arg real(ip42      ) ; composante en y du vecteur directeur
!_I                                        normal a une facette frontiere
!_I    nzn        : arg real(ip42      ) ; composante en z du vecteur directeur
!_I                                        normal a une facette frontiere
!_I    v          : arg real(ip11,ip60 ) ; variables a l'instant n+alpha
!_I    toxx       : arg real(ip12      ) ; composante en xx du tenseur des
!_I                                        contraintes visqueuses
!_I    toxy       : arg real(ip12      ) ; composante en xy du tenseur des
!_I                                        contraintes visqueuses
!_I    toxz       : arg real(ip12      ) ; composante en xz du tenseur des
!_I                                        contraintes visqueuses
!_I    toyy       : arg real(ip12      ) ; composante en yy du tenseur des
!_I                                        contraintes visqueuses
!_I    toyz       : arg real(ip12      ) ; composante en yz du tenseur des
!_I                                        contraintes visqueuses
!_I    tozz       : arg real(ip12      ) ; composante en zz du tenseur des
!_I                                        contraintes visqueuses
!_I    qtx        : arg real(ip40      ) ; composante en x flux de chaleur
!_I    qty        : arg real(ip40      ) ; composante en y flux de chaleur
!_I    qtz        : arg real(ip40      ) ; composante en z flux de chaleur
!_I    cl         : com char(mtb       ) ; type de cond lim a appliquer
!_I    img        : com int              ; niveau de grille (multigrille)
!_I    mtbx       : com int              ; nbr total de frontieres
!_I    nnn        : com int (lt        ) ; nombre de noeuds du dom (dont fic.)
!_I    npfb       : com int (lt        ) ; pointeur fin de dom precedent
!_I                                        dans tab toutes facettes
!_I    mmb        : com int (mtt       ) ; nombre de facettes d'une frontiere
!_I    mpb        : com int (mtt       ) ; pointeur fin de front precedente
!_I                                        dans tableaux de base des front.
!_I    mpd        : com int (mtt       ) ; tableau de pointeur sur l'ensemble
!_I                                        des frontieres
!_I    ldp        : com int(           ) ; tableau des labels des noeuds deplaces
!_I    nba        : com int (mtb       ) ; rang de traitement d'une front
!_I    ndlb       : com int (mtb       ) ; numero dom contenant la frontiere
!_I    mpn        : com int (mtt       ) ; pointeur fin de front precedente
!_I                                        dans tab front a normales stockees
!_I    nbd        : com int              ; nombre de frontieres a traiter
!_I    lbd        : com int (mtt       ) ; numero de front a traiter
!
!
!-----parameters figes--------------------------------------------------
!
    use para_var
    use para_fige
    use maillage
    use boundary
    use mod_lparoi4
    use mod_lparoi3d
    implicit none
    integer          ::        img,       mfb,ncbd(ip41),ncin(ip41),      ncyc
    integer          ::         no
    double precision ::    nxn(ip42),   nyn(ip42),   nzn(ip42),   qcx(ip12),   qcy(ip12)
    double precision ::    qcz(ip12),  topz(ip11),  toxx(ip12),  toxy(ip12),  toxz(ip12)
    double precision ::   toyy(ip12),  toyz(ip12),  tozz(ip12),  utau(ip42),v(ip11,ip60)
    double precision ::  ztemp(ip11)
!
!-----------------------------------------------------------------------
!
!

!    boucle sur toutes les frontieres
    do no=1,mtbx
       mfb=nba(no)
!      lois de paroi en parois adiabatiques
       if(cl(mfb)(1:3).eq.'lp4') then
!          if((ncyc.lt.icytur0)) then
          call lparoi4( &
               ncyc, &
               nxn,nyn,nzn,  &
               ncin,ncbd,mfb, &
               toxx,toxy,toxz,toyy,toyz,tozz, &
               qcx,qcy,qcz, &
               v,utau,ztemp)
!
       elseif(cl(mfb)(1:3).eq.'lp5') then
          call lparoi3d( &
               ncyc, &
               nxn,nyn,nzn, &
               ncin,ncbd,mfb, &
               toxx,toxy,toxz,toyy,toyz,tozz, &
               qcx,qcy,qcz, &
               v,utau,ztemp,topz)
       endif
    enddo
!
    return
  end subroutine cllparoi2
end module mod_cllparoi2
