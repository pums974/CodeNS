module mod_at_ecrdist
  implicit none
contains
  subroutine at_ecrdist( &
       l0,         &
       dist,mnpar)
!
!***********************************************************************
!
!     ACT
!_A    ecriture des distances pour un domaine
!
!-----parameters figes--------------------------------------------------
!
    use para_var
    use para_fige
    use sortiefichier
    use maillage
    use mod_mpi
    implicit none
    integer          ::           i,         i1,         i2,       i2m1,        iwd
    integer          ::           j,         j1,         j2,       j2m1,          k
    integer          ::          k1,         k2,       k2m1,          l,         l0
    integer          :: mnpar(ip12),         n0,        nid,       nijd,        njd,ll
    double precision :: dist(ip12)
!
!-----------------------------------------------------------------------
!
    character(len=8) :: nomfich
!

!
    iwd=98
    if(l0.eq.0) then
!       ecriture tous les domaines dans "fdist"
!
       nomfich='fdist   '
!
       if(rank==0) write(imp,'("===>at_ecrdist: distance tous domaines   fichier=",a8)')nomfich
!
       do l=1,lzx
         ll=bl_to_bg(l)
         call start_keep_order(ll,bg_to_proc)
         open(iwd,file=nomfich,form='unformatted',err=50,position="append")
         if(ll==1) rewind(iwd)
          n0=npc(l)
          i1=ii1(l)
          i2=ii2(l)
          j1=jj1(l)
          j2=jj2(l)
          k1=kk1(l)
          k2=kk2(l)
          i2m1=i2-1
          j2m1=j2-1
          k2m1=k2-1
          nid = id2(l)-id1(l)+1
          njd = jd2(l)-jd1(l)+1
          nijd = nid*njd
!
          write(iwd)(((dist (ind(i,j,k)),i=i1,i2m1),j=j1,j2m1), &
               k=k1,k2m1)
          write(iwd)(((mnpar(ind(i,j,k)),i=i1,i2m1),j=j1,j2m1), &
               k=k1,k2m1)
         close(iwd)
         call end_keep_order(ll,bg_to_proc)
       end do
    else
!       ecriture un seul domaine par fichier
!
       l=l0
       ll=bl_to_bg(l)
       if(ll.le.9 ) then
          write(nomfich,'("fdist_",i1," ")')ll
       else if(ll.le.99) then
          write(nomfich,'("fdist_",i2)')ll
       else
          write(imp,'("!!!at_ecrdist: plus de 99 domaines. Non prevu")')
          stop
       end if
!
       write(imp,'("===>at_ecrdist: ecriture distance domaine",i2,"   fichier=",a8)')ll,nomfich
!
       open(iwd,file=nomfich,form='unformatted',err=50)
!
       n0=npc(l)
       i1=ii1(l)
       i2=ii2(l)
       j1=jj1(l)
       j2=jj2(l)
       k1=kk1(l)
       k2=kk2(l)
       i2m1=i2-1
       j2m1=j2-1
       k2m1=k2-1
       nid = id2(l)-id1(l)+1
       njd = jd2(l)-jd1(l)+1
       nijd = nid*njd
!
       write(iwd)(((dist (ind(i,j,k)),i=i1,i2m1),j=j1,j2m1),k=k1,k2m1)
       write(iwd)(((mnpar(ind(i,j,k)),i=i1,i2m1),j=j1,j2m1),k=k1,k2m1)
       close(iwd)
    end if
!
    write(imp,'("===>at_ecrdist: fin ecriture fichier=",a8)')nomfich
!
    if(bl_to_bg(l).eq.1) then ! TODO : WHAT IS THAT
!       ecriture fichier auxiliaire des donnees necessaires a la relecture
!
       if(rank==0) then
         write(imp,'("===>at_ecrdist: ecriture fichier= fdist-aux")')
         write(imp,'(16x,"ip12=",i8)') ip12
       endif
       do l=1,lzx
          ll=bl_to_bg(l)
         call start_keep_order(ll,bg_to_proc)
         open(iwd,file='fdist-aux',form='formatted',err=60,position="append")
         if(ll==1) rewind(iwd)
          write(iwd,'(i3,i8,6i5)') &
               ll,npc(l),ii1(l),ii2(l),jj1(l),jj2(l),kk1(l),kk2(l)
          write(iwd,'(i3,i8,6i5)') &
               ll,npc(l),id1(l),id2(l),jd1(l),jd2(l),kd1(l),kd2(l)
       close(iwd)
        call end_keep_order(ll,bg_to_proc)
       end do
    end if
    return
!
50  continue
    write(imp,'("!!!at_ecrdist: erreur ouverture fichier=",a8)') &
         nomfich
60  continue
    write(imp,'("!!!at_ecrdist: erreur ouverture fichier=fdist-aux")')
    stop
!
  contains
    function    ind(i,j,k)
      implicit none
      integer          ::   i,ind,  j,  k
      ind=n0+1+(i-id1(l))+(j-jd1(l))*nid+(k-kd1(l))*nijd
    end function ind
  end subroutine at_ecrdist


end module mod_at_ecrdist
