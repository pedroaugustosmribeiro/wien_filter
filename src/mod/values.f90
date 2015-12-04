module values
  implicit none
  integer,parameter :: rk=selected_real_kind(15,307)
  real(rk),parameter :: qe=1.60217662e-19,me=9.10938356e-31
  !qe: elementar charge (charge of electron) in C
  !me: mass of electron in kg

contains
  
  function cross(a,b)
    real(rk),intent(in),dimension(3) :: a,b
    real(rk) :: cross(3)

    cross=[(a(2)*b(3)-a(3)*b(2)),(a(3)*b(1)-a(1)*b(3)),(a(1)*b(2)-a(2)*b(1))]
  end function cross
  
end module values
