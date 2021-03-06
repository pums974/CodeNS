module mod_utnrd
  implicit none
contains
  subroutine utnrd( &
       bceqt, &
       mfl,l,rod,roud,rovd,rowd,roed, &
       ncbd, &
       y,z)
!
!***********************************************************************
!
!     ACT
!_A    Sous-programme utilisateur de preparation des donnees pour le
!_A    sous-programme clnrd.
!_A    Il doit remplir les tableaux rod,roud,rovd,rowd,roed des
!_A    variables conservatives.
!_A
!_A     Valeurs calculees pour un ecoulement de meme valeurs d'arret que
!_A     l'etat thermodynamique a1 (common sta1), de nombre de mach rmach et
!_A     cosinus directeurs alpha0 et beta0 fournis dans utdon.
!
!     INP
!_I    roa1       : com real             ; etat de reference utilisateur
!_I                                        adimensionne, masse volumique d'arret
!_I    aa1        : com real             ; etat de reference utilisateur
!_I                                        adimensionne, vitesse du son d'arret
!_I    pa1        : com real             ; pression d'arret de l'etat
!_I                                        de reference utilisateur adimensionne
!_I    gam        : com real             ; rapport des chaleurs specifiques
!_I    gam1       : com real             ; gam -1
!_I    gam2       : com real             ; (gam -1)/2
!_I    gam4       : com real             ; 1/(gam -1)
!_I    rmach      : com real             ; nbr de Mach de l'etat a imposer
!_I    alpha0     : com real             ; angle d'incidence de l'etat a imposer
!_I    beta0      : com real             ; angle de derapage de l'etat a imposer
!
!     OUT
!_O    rod        : arg real(ip40      ) ; masse volumique donnee
!_O    roud       : arg real(ip40      ) ; ro*u donne, ro masse volumique
!_O                                        et u composante en x de la vitesse
!_O    rovd       : arg real(ip40      ) ; ro*v donne, ro masse volumique
!_O                                        et v composante en y de la vitesse
!_O    rowd       : arg real(ip40      ) ; ro*w donne, ro masse volumique
!_O                                        et w composante en z de la vitesse
!_O    roed       : arg real(ip40      ) ; ro*e donne, ro masse volumique
!_O                                        et e energie interne
!-----parameters figes--------------------------------------------------
!
    use para_var
    use para_fige
    use maillage
    use definition
    use proprieteflu
    use boundary
    implicit none
    integer          ::          l,         m
    integer          ::        mfl,        ml,        mt,       n0c,       n0n
    integer          ::         nc,ncbd(ip41),       nci,      ncij,     ncijk
    integer          ::       ncik,       ncj,      ncjk,       nck,       nid
    integer          ::       nijd,       njd,        nn
    double precision ::                a,          alpha0,          alphar,bceqt(ip41,neqt),           beta0
    double precision ::            betar,          degrad,               p,            pis2,               q
    double precision ::            rmach,              ro,       rod(ip40),             roe,      roed(ip40)
    double precision ::              rou,      roud(ip40),             rov,      rovd(ip40),             row
    double precision ::       rowd(ip40),         y(ip21),              ym,         z(ip21),              zm
!
!-----------------------------------------------------------------------
!
!

!
    n0n=npn(l)
    n0c=npc(l)
!
    nid = id2(l)-id1(l)+1
    njd = jd2(l)-jd1(l)+1
    nijd = nid*njd
!
    nci = inc(1,0,0)
    ncj = inc(0,1,0)
    nck = inc(0,0,1)
    ncij = inc(1,1,0)
    ncik = inc(1,0,1)
    ncjk = inc(0,1,1)
    ncijk= inc(1,1,1)
!
    pis2=atan2(1.D0,0.D0)
    degrad=pis2/90.D0
!
    ml=mpb(mfl)+1
    rmach=bceqt(ml,1)
    alpha0=bceqt(ml,2)
    beta0=bceqt(ml,3)
!
    ro=roa1/(1.+gam2*rmach**2)**gam4
    a=aa1/(1.+gam2*rmach**2)**.5
    p=pa1/(1.+gam2*rmach**2)**(gam/gam1)
    q=rmach*a
    alphar=alpha0*degrad
    betar=beta0*degrad
    rou=ro*q*cos(alphar)*cos(betar)
    rov=-ro*q*sin(betar)
    row=ro*q*sin(alphar)*cos(betar)
    roe=p/gam1+pinfl+0.5*ro*q**2
!
    mt=mmb(mfl)
    do m=1,mt
       ml=mpb(mfl)+m
       nc=ncbd(ml)
       nn=nc-n0c+n0n
!
       ym  = 0.125*( y (nn     )+y (nn+nci  ) &
            +y (nn+ncj )+y (nn+ncij ) &
            +y (nn+nck )+y (nn+ncik ) &
            +y (nn+ncjk)+y (nn+ncijk) )
       zm  = 0.125*( z (nn     )+z (nn+nci  ) &
            +z (nn+ncj )+z (nn+ncij ) &
            +z (nn+nck )+z (nn+ncik ) &
            +z (nn+ncjk)+z (nn+ncijk) )
!
       rod(m) =ro
       roud(m)=rou
       rovd(m)=rov+omg*zm*ro
       rowd(m)=row-omg*ym*ro
       roed(m)=roe+.5*(rovd(m)**2-rov**2+rowd(m)**2-row**2)/ro
    enddo
!
    return
  contains
    function    inc(id,jd,kd)
      implicit none
      integer          ::  id,inc, jd, kd
      inc=id+jd*nid+kd*nijd
    end function inc
  end subroutine utnrd
end module mod_utnrd
