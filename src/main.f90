program wien_filter
  use values
  use phys
  use verlet
  use cmd_line
  implicit none
  character(len=MAXBUF) :: inputfile,outputfile,whatever
  integer :: ios1,ios2
  integer(ik) :: i,p,n_p,position
  real(rk) :: e_in,b_in,m,q,dt
  real(rk),allocatable :: n(:),m_i(:),q_i(:),v_i(:,:),x_f(:,:),v_f(:,:)
  real(rk),dimension(3) :: L,x,v,a,E,B
  logical,allocatable :: passed(:)

  L=1e-2_rk*[1.9_rk,7.6_rk,1.9_rk] !in meters

  !data input section

  dt=cmd2real(1)
  b_in=cmd2real(2)
  e_in=cmd2real(3)
  call get_command_argument(4,inputfile,status=ios1)
  call get_command_argument(5,outputfile,status=ios2)

  !error checking
  check_input: if (any(([dt,b_in,e_in])==outreal).or.any(([ios1,ios2])/=0)) then
     print *,'wien_filter [dt] [Bx] [Ez] [input file] [output file]'
     stop
  end if check_input

  !input file opening
  open(10,file=inputfile,iostat=ios1,action='read')
  if (ios1/=0) then
     print *,"Sorry, can't read file: ",trim(inputfile)
  end if
  !input file reading
  n_p=0
  count_lines: do while(ios1==0)
     read(10,*,iostat=ios1) whatever
     n_p=n_p+1
  end do count_lines
  n_p=n_p-1
  rewind 10
  allocate(n(n_p),v_i(3,n_p),m_i(n_p),q_i(n_p),passed(n_p),v_f(3,n_p),x_f(3,n_p))

  read_file: do p=1,n_p
     read(10,*) n(p),v_i(:,p),m_i(p),q_i(p)
  end do read_file
  close(10)

  !fields initialization
  E=real([0,0,1],rk)*e_in !in V/m
  B=real([1,0,0],rk)*b_in !in T

  q_i=q_i*qe
  m_i=abs(m_i)*me
  !$OMP PARALLEL DO ORDERED SCHEDULE(runtime)
  particles: do  p=1,n_p

     !particle initialization
     !n: particle number
     !v_i: initial velocity
     q=q_i(p)
     m=m_i(p)
     !m_i: mass of particle in units of electron mass
     !q_i: charge of particle in units of electron charge
     !Note that mass can't be negative (automatic error correction)

     x=[L(1)/2,.0_rk,L(3)/2] !initial position at the center of the box
     v=v_i(:,p)
     a=fl(q,m,E,B,v)
     i=0
     !$OMP ORDERED
     simulation:  do

        !stop criterias
        if ((abs(x(1))>=L(1)).or.(abs(x(3))>=L(3))) then
           print *,n(p),'filtered in',i !unsuccesful :(
           passed(p)=.false.
           exit
        else if (x(2)>=L(2)) then
           print *,n(p),'passed in ',i !succesful :)
           passed(p)=.true.
           v_f(:,p)=v
           x_f(:,p)=x
           exit
        end if

        call integrate(E,B,dt,q,m,x,v,a) !integrate subroutine in verlet.f90 module
        i=i+1
     end do simulation
     !$OMP END ORDERED
  end do particles
  !$OMP END PARALLEL DO
  !output file opening
  open(20,file=outputfile,iostat=ios2,action='write')
  if (ios2/=0) then
     print *,"Sorry, can't write to file: ",trim(outputfile)
  end if
  write_file:do p=1,n_p
     if (passed(p)) then
        write(20,'(i0,x,8(g,x))') p,v_f(:,p),x_f(:,p),m_i(p),q_i(p)
     end if
  end do write_file

  close(20)

end program wien_filter
