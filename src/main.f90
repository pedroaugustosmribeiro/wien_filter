program wien_filter
  use values
  use phys
  use verlet
  use cmd_line
  implicit none
  integer(ik) :: i,p,n_p,n
  real(rk) :: e_in,b_in,m_i,q_i,m,q,dt
  real(rk),dimension(3) :: L,v_i,x,v,a,E,B

  L=1e-2_rk*[1.9_rk,7.6_rk,1.9_rk] !in meters

  !data input section

  dt=cmd2real(1)
  b_in=cmd2real(2)
  e_in=cmd2real(3)

  !error checking
  check_input: if (any(([dt,b_in,e_in])==outreal)) then
     print *,'wien_filter [dt] [Bx] [Ez]'
     stop
  end if check_input

  !input file opening
  open(1,file='../run/input.dat',action='read')
  read(1,*),n_p

  !fields initialization
  E=real([0,0,1],rk)*e_in !in V/m
  B=real([1,0,0],rk)*b_in !in T

  particles: do p=1,n_p

     !particle initialization
     read(1,*),n,v_i,m_i,q_i
     q=q_i*qe !in C
     m=m_i*me !in kg

     x=[L(1)/2,.0_rk,L(3)/2]
     v=v_i
     a=fl(q,m,E,B,v)
     i=0

     simulation:  do

        !stop criterias
        if ((abs(x(1))>=L(1)).or.(abs(x(3))>=L(3))) then
           print *,n,'filtered in',i !unsuccesful :(
           exit
        else if (x(2)>=L(2)) then
           print *,n,'passed in ',i !succesful :)
           print *,v
           print *,x
           exit
        end if

        call integrate(E,B,dt,q,m,x,v,a) !integrate subroutine in verlet.f90 module
        i=i+1
     end do simulation

  end do particles

  close(1)
  
end program wien_filter
