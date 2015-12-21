#! /bin/bash
fcomp=$1
fmode=$2
fopt=``
    if [ "$fcomp" == 'ifort' ]; then
	fopt='-fast'
    elif [ "$fcomp" == 'gfortran' ]; then
	fopt='-O3'
    else
	echo './build.sh [ifort or gfortran]'
	exit 1
    fi	
$fcomp -c $fopt mod/values.f90
$fcomp -c $fopt mod/*.f90
$fcomp  $fopt main.f90 *.o -o wien_filter
rm *.o
rm *.mod
