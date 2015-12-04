program wien_filter
  use valuesk
  use phys
  use verlet
  use cmd_line
  implicit none
  integer(8) :: i,particle,n_particles
  real(rk) :: e_in,b_in
  real(rk),dimension(3) :: L

  L=1e-2_rk*[1.9_rk,7.6_rk,1.9_rk] !in meters

  !data input section
  
  dt=cmd2real(1)!1e-6_rk
  b_in=cmd2real(2)
  e_in=cmd2real(3)

  check_input: if (any(([dt,b_in,e_in])==outreal)) then
     print *,'wien_filter [dt] [Bx] [Ez]'
     stop
  end if check_input

  !fields initialization
  E=real([0,0,1],rk)*e_in !in V/m
  B=real([1,0,0],rk)*b_in !in T

  particles: do particle=0,n_particles
     !particle initialization
     q=-qe !in C
     m=me !in kg

     x=[L(1)/2,.0_rk,L(3)/2]
     v=real([0,1,0],rk)
     a=fl(q,m,E,B,v)
     !print *,q,m
     i=0
     simulation:  do
        !print *,i
        print *,x(2)!'x= ',x
        !print *,'v= ',v
        !print *,'a= ',a
        !print *

        !stop criterias
        if ((abs(x(1))>=L(1)).or.(abs(x(3))>=L(3))) then
           print *,'filtered in',i !unsuccesful :(
           exit
        else if (x(2)>=L(2)) then
           print *,'passed in ',i !succesful :)
           exit
        end if

        call integrate() !integrate subroutine in verlet.f90 module
        i=i+1
     end do simulation

  end do particles

end program wien_filter
