module cmd_line
  use values
  implicit none
  integer,parameter,private :: MAXBUF=200
  character(len=MAXBUF),private :: argu
  real(rk),parameter :: outreal=huge(1.0_rk)
contains

  ! function cmd2real(i) 
  ! of type real(rk) that reads the ith command line
  ! argument, converts it to real(rk) and returns this value

  real(rk) function cmd2real(i)
    implicit none
    integer,intent(in) :: i
    integer :: ios
    call get_command_argument(i,argu)
    read(argu,*,iostat=ios),cmd2real
    if (ios/=0) then
       cmd2real=outreal
       return
    else
       return
    end if
  end function cmd2real

end module cmd_line
