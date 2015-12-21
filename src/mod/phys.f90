module phys
  use values

contains
  
  pure function fl(q,m,E,B,v)
    real(rk),intent(in) :: q,m
    real(rk),intent(in),dimension(3) :: E,B,v
    real(rk) :: fl(3)

    fl=(q*(E+cross(v,B)))/m

  end function fl
  

end module phys
