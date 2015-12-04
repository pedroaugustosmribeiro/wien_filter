module verlet
  use values
  use phys
  implicit none
  real(rk) :: q,m
  real(rk),dimension(3) :: x,v,E,B,dt,a

contains

  subroutine integrate()
    real(rk),dimension(3) :: a_old,vn

    x=x+v*dt+a*(dt**2)
    vn=v+a*dt
    a_old=a
    a=fl(q,m,E,B,vn)
    v=v+0.5_rk*(a_old+a)*dt

  end subroutine integrate

end module verlet
