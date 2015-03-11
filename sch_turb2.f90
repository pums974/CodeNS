module mod_sch_turb2
implicit none
contains
      subroutine sch_turb2( &
                 l,u,v,d, &
                 fd5x,fd5y,fd5z,fd6x,fd6y,fd6z,ts6,ts7, &
                 equat,ncin, &
                 sn,lgsnlt, &
                 vol, &
                 f6x,f6y,f6z,f7x,f7y,f7z, &
                 cmui1,cmui2,cmuj1,cmuj2,cmuk1,cmuk2)
!
!***********************************************************************
!
!_DA  DATE_C : mars 2002 - Eric GONCALVES / Sinumef
!
!     ACT
!_A    Calcul des bilans de flux physiques pour chaque cellule.
!_A    Schemas de Jameson et Roe.
!_A    Ponderation pour maillage irregulier.
!
!-----parameters figes--------------------------------------------------
!
      use para_var
      use para_fige
      use maillage
      use modeleturb
use mod_met_pardis
implicit none
integer :: inc
integer :: indc
integer :: id
integer :: jd
integer :: kd
integer :: i
integer :: j
integer :: k
integer :: l
double precision :: u
double precision :: v
double precision :: d
double precision :: fd5x
double precision :: fd5y
double precision :: fd5z
double precision :: fd6x
double precision :: fd6y
double precision :: fd6z
double precision :: ts6
double precision :: ts7
integer :: ncin
double precision :: sn
integer :: lgsnlt
double precision :: vol
double precision :: f6x
double precision :: f6y
double precision :: f6z
double precision :: f7x
double precision :: f7y
double precision :: f7z
double precision :: cmui1
double precision :: cmui2
double precision :: cmuj1
double precision :: cmuj2
double precision :: cmuk1
double precision :: cmuk2
integer :: i1
integer :: i1m1
integer :: i1p1
integer :: i2
integer :: i2m1
integer :: ind1
integer :: ind2
integer :: j1
integer :: j1m1
integer :: j1p1
integer :: j2
integer :: j2m1
integer :: k1
integer :: k1m1
integer :: k1p1
integer :: k2
integer :: k2m1
integer :: kdir
integer :: m
integer :: n
integer :: n0c
integer :: nci
integer :: ncj
integer :: nck
integer :: nid
integer :: nijd
integer :: ninc
integer :: njd
double precision :: si6
double precision :: si7
double precision :: sj6
double precision :: sj7
double precision :: sk6
double precision :: sk7
!
!-----------------------------------------------------------------------
!
      character(len=7 ) :: equat
      dimension u(ip11,ip60),v(ip11,ip60),d(ip11,ip60)           
      dimension fd5x(ip12),fd5y(ip12),fd5z(ip12), &
                fd6x(ip12),fd6y(ip12),fd6z(ip12), &
                ts6(ip12),ts7(ip12)
      dimension sn(lgsnlt,nind,ndir)
      dimension ncin(ip41),vol(ip11)
      dimension cmui1(ip21),cmui2(ip21),cmuj1(ip21),cmuj2(ip21),cmuk1(ip21),cmuk2(ip21)
      dimension f6x(ip00),f6y(ip00),f6z(ip00), &
                f7x(ip00),f7y(ip00),f7z(ip00)
!
      indc(i,j,k)=n0c+1+(i-id1(l))+(j-jd1(l))*nid+(k-kd1(l))*nijd
      inc(id,jd,kd)=id+jd*nid+kd*nijd

      n0c=npc(l)
      i1=ii1(l)
      i2=ii2(l)
      j1=jj1(l)
      j2=jj2(l)
      k1=kk1(l)
      k2=kk2(l)
!
      nid = id2(l)-id1(l)+1
      njd = jd2(l)-jd1(l)+1
      nijd = nid*njd
!
      i1p1=i1+1
      j1p1=j1+1
      k1p1=k1+1
      i2m1=i2-1
      j2m1=j2-1
      k2m1=k2-1
      i1m1=i1-1
      j1m1=j1-1
      k1m1=k1-1
!
      nci = inc(1,0,0)
      ncj = inc(0,1,0)
      nck = inc(0,0,1)
!
!-----initalisation----------------------------------------------------
!
      ind1 = indc(i1m1,j1m1,k1m1)
      ind2 = indc(i2  ,j2  ,k2  )
      do n=ind1,ind2
       u(n,6)=0.
       u(n,7)=0.
      enddo
!
!-----calcul des densites de flux ----------------------------------------
!
      if(equat(3:5).eq.'2dk') then
       ind1 = indc(i1m1,j1m1,k1  )
       ind2 = indc(i2  ,j2  ,k2m1)
      elseif(equat(3:4).eq.'3d') then
       ind1 = indc(i1m1,j1m1,k1m1)
       ind2 = indc(i2  ,j2  ,k2  )
      endif
!
      do n=ind1,ind2
       m=n-n0c
       f6x(m)=v(n,6)*(v(n,2)/v(n,1))-fd5x(n)
       f6y(m)=v(n,6)*(v(n,3)/v(n,1))-fd5y(n)
       f6z(m)=v(n,6)*(v(n,4)/v(n,1))-fd5z(n)
       f7x(m)=v(n,7)*(v(n,2)/v(n,1))-fd6x(n)
       f7y(m)=v(n,7)*(v(n,3)/v(n,1))-fd6y(n)
       f7z(m)=v(n,7)*(v(n,4)/v(n,1))-fd6z(n)
      enddo
!
!*********************************************************************
!      calcul des flux numeriques par direction
!*********************************************************************
!
!------direction i----------------------------------------------
!
      kdir=1
      ninc=nci
!
      do k=k1,k2m1
       do j=j1,j2m1
        ind1 = indc(i1p1,j,k)
        ind2 = indc(i2m1,j,k)
!DEC$ IVDEP
        do n=ind1,ind2
         m=n-n0c
         si6= (cmui1(m)*f6x(m)+cmui2(m)*f6x(m-ninc))*sn(m,kdir,1) &
             +(cmui1(m)*f6y(m)+cmui2(m)*f6y(m-ninc))*sn(m,kdir,2) &
             +(cmui1(m)*f6z(m)+cmui2(m)*f6z(m-ninc))*sn(m,kdir,3)
         si7= (cmui1(m)*f7x(m)+cmui2(m)*f7x(m-ninc))*sn(m,kdir,1) &
             +(cmui1(m)*f7y(m)+cmui2(m)*f7y(m-ninc))*sn(m,kdir,2) &
             +(cmui1(m)*f7z(m)+cmui2(m)*f7z(m-ninc))*sn(m,kdir,3)
         u(n,6)=u(n,6)-si6
         u(n,7)=u(n,7)-si7
         u(n-ninc,6)=u(n-ninc,6)+si6
         u(n-ninc,7)=u(n-ninc,7)+si7
        enddo
       enddo
      enddo
!
      do k=k1,k2m1
       ind1 = indc(i1,j1  ,k)
       ind2 = indc(i1,j2m1,k)
!DEC$ IVDEP
       do n=ind1,ind2,ncj
        m=n-n0c
        si6= 2*f6x(m-ninc)*sn(m,kdir,1) &
            +2*f6y(m-ninc)*sn(m,kdir,2) &
            +2*f6z(m-ninc)*sn(m,kdir,3)
        si7= 2*f7x(m-ninc)*sn(m,kdir,1) &
            +2*f7y(m-ninc)*sn(m,kdir,2) &
            +2*f7z(m-ninc)*sn(m,kdir,3)
        u(n,6)=u(n,6)-si6
        u(n,7)=u(n,7)-si7
       enddo
      enddo
!
      do k=k1,k2m1
       ind1 = indc(i2,j1  ,k)
       ind2 = indc(i2,j2m1,k)
!DEC$ IVDEP
       do n=ind1,ind2,ncj
        m=n-n0c
        si6= 2*f6x(m)*sn(m,kdir,1) &
            +2*f6y(m)*sn(m,kdir,2) &
            +2*f6z(m)*sn(m,kdir,3)
        si7= 2*f7x(m)*sn(m,kdir,1) &
            +2*f7y(m)*sn(m,kdir,2) &
            +2*f7z(m)*sn(m,kdir,3)
        u(n-ninc,6)=u(n-ninc,6)+si6
        u(n-ninc,7)=u(n-ninc,7)+si7
       enddo
      enddo
!
!------direction j----------------------------------------------
!
      kdir=2
      ninc=ncj
!
      do k=k1,k2m1
       do j=j1p1,j2m1
        ind1 = indc(i1,j,k)
        ind2 = indc(i2m1,j,k)
!DEC$ IVDEP
        do n=ind1,ind2
         m=n-n0c
         sj6= (cmuj1(m)*f6x(m)+cmuj2(m)*f6x(m-ninc))*sn(m,kdir,1) &
             +(cmuj1(m)*f6y(m)+cmuj2(m)*f6y(m-ninc))*sn(m,kdir,2) &
             +(cmuj1(m)*f6z(m)+cmuj2(m)*f6z(m-ninc))*sn(m,kdir,3)
         sj7= (cmuj1(m)*f7x(m)+cmuj2(m)*f7x(m-ninc))*sn(m,kdir,1) &
             +(cmuj1(m)*f7y(m)+cmuj2(m)*f7y(m-ninc))*sn(m,kdir,2) &
             +(cmuj1(m)*f7z(m)+cmuj2(m)*f7z(m-ninc))*sn(m,kdir,3)
         u(n,6)=u(n,6)-sj6
         u(n,7)=u(n,7)-sj7
         u(n-ninc,6)=u(n-ninc,6)+sj6
         u(n-ninc,7)=u(n-ninc,7)+sj7
        enddo
       enddo
      enddo
!
      do k=k1,k2m1
       ind1 = indc(i1  ,j1,k)
       ind2 = indc(i2m1,j1,k)
!DEC$ IVDEP
       do n=ind1,ind2
        m=n-n0c
        sj6= 2*f6x(m-ninc)*sn(m,kdir,1) &
            +2*f6y(m-ninc)*sn(m,kdir,2) &
            +2*f6z(m-ninc)*sn(m,kdir,3)
        sj7= 2*f7x(m-ninc)*sn(m,kdir,1) &
            +2*f7y(m-ninc)*sn(m,kdir,2) &
            +2*f7z(m-ninc)*sn(m,kdir,3)
        u(n,6)=u(n,6)-sj6
        u(n,7)=u(n,7)-sj7
       enddo
      enddo
!
      do k=k1,k2m1
       ind1 = indc(i1  ,j2,k)
       ind2 = indc(i2m1,j2,k)
!DEC$ IVDEP
       do n=ind1,ind2
        m=n-n0c
        sj6= 2*f6x(m)*sn(m,kdir,1) &
            +2*f6y(m)*sn(m,kdir,2) &
            +2*f6z(m)*sn(m,kdir,3)
        sj7= 2*f7x(m)*sn(m,kdir,1) &
            +2*f7y(m)*sn(m,kdir,2) &
            +2*f7z(m)*sn(m,kdir,3)
        u(n-ninc,6)=u(n-ninc,6)+sj6
        u(n-ninc,7)=u(n-ninc,7)+sj7
       enddo
      enddo
!
!------direction k----------------------------------------------
!
      if(equat(3:4).eq.'3d') then
       kdir=3
       ninc=nck
!
      do k=k1p1,k2m1
       do j=j1,j2m1
        ind1 = indc(i1  ,j,k)
        ind2 = indc(i2m1,j,k)
!DEC$ IVDEP
        do n=ind1,ind2
         m=n-n0c
         sk6= (cmuk1(m)*f6x(m)+cmuk2(m)*f6x(m-ninc))*sn(m,kdir,1) &
             +(cmuk1(m)*f6y(m)+cmuk2(m)*f6y(m-ninc))*sn(m,kdir,2) &
             +(cmuk1(m)*f6z(m)+cmuk2(m)*f6z(m-ninc))*sn(m,kdir,3)
         sk7= (cmuk1(m)*f7x(m)+cmuk2(m)*f7x(m-ninc))*sn(m,kdir,1) &
             +(cmuk1(m)*f7y(m)+cmuk2(m)*f7y(m-ninc))*sn(m,kdir,2) &
             +(cmuk1(m)*f7z(m)+cmuk2(m)*f7z(m-ninc))*sn(m,kdir,3)
         u(n,6)=u(n,6)-sk6
         u(n,7)=u(n,7)-sk7
         u(n-ninc,6)=u(n-ninc,6)+sk6
         u(n-ninc,7)=u(n-ninc,7)+sk7
        enddo
       enddo
      enddo
!
      do j=j1,j2m1
       ind1 = indc(i1  ,j,k1)
       ind2 = indc(i2m1,j,k1)
!DEC$ IVDEP
       do n=ind1,ind2
        m=n-n0c
        sk6= 2*f6x(m-ninc)*sn(m,kdir,1) &
            +2*f6y(m-ninc)*sn(m,kdir,2) &
            +2*f6z(m-ninc)*sn(m,kdir,3)
        sk7= 2*f7x(m-ninc)*sn(m,kdir,1) &
            +2*f7y(m-ninc)*sn(m,kdir,2) &
            +2*f7z(m-ninc)*sn(m,kdir,3)
        u(n,6)=u(n,6)-sk6
        u(n,7)=u(n,7)-sk7
       enddo
      enddo
!
      do j=j1,j2m1
       ind1 = indc(i1  ,j,k2)
       ind2 = indc(i2m1,j,k2)
!DEC$ IVDEP
       do n=ind1,ind2
        m=n-n0c
        sk6= 2*f6x(m)*sn(m,kdir,1) &
            +2*f6y(m)*sn(m,kdir,2) &
            +2*f6z(m)*sn(m,kdir,3)
        sk7= 2*f7x(m)*sn(m,kdir,1) &
            +2*f7y(m)*sn(m,kdir,2) &
            +2*f7z(m)*sn(m,kdir,3)
        u(n-ninc,6)=u(n-ninc,6)+sk6
        u(n-ninc,7)=u(n-ninc,7)+sk7
       enddo
      enddo
      endif
!
!      if((kditur.eq.1).and.(kparoi.eq.1).and.(lparoi.lt.1)) then
      if((kparoi.eq.1).and.(lparoi.lt.1)) then
!     Suppression de la dissipation artificielle pour omega pres
!     de la paroi sur 3 couches de cellule - Schema de Jameson
!     modele k-omega de Wilcox et Menter
              call met_pardis(ncin,d)
      endif
!
!****************************************************************
!      calcul de l'increment explicite par maille
!****************************************************************
!
       do k=k1,k2m1
        do j=j1,j2m1
         ind1=indc(i1  ,j,k)
         ind2=indc(i2m1,j,k)
         do n=ind1,ind2
          m=n-n0c
          u(n,6)=0.5*u(n,6) - vol(n)*ts6(n) - d(n,6)
          u(n,7)=0.5*u(n,7) - vol(n)*ts7(n) - d(n,7)
         enddo
        enddo
       enddo

      return
      end subroutine
end module
