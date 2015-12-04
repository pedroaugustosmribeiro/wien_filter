module phys
  use values

contains
  
  function fl(q,m,E,B,v)
    real(rk),intent(in) :: q,m
    real(rk),intent(in),dimension(3) :: E,B,v
    real(rk) :: fl(3)

    fl=(q/m)*(E+cross(v,B))
    
  end function fl
  

end module phys
