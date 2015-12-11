module verlet
  use values
  use phys
  implicit none

contains

  pure subroutine integrate(E,B,dt,q,m,x,v,a)
    real(rk),intent(in),dimension(3) :: E,B
    real(rk),intent(in) :: dt,q,m
    real(rk),intent(inout),dimension(3) :: x,v,a
    real(rk),dimension(3) :: vn

    x=x+v*dt+a*(dt**2)
    vn=v+a*dt
    v=v+0.5_rk*(a+fl(q,m,E,B,vn))*dt

  end subroutine integrate

end module verlet
