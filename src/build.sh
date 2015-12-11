#! /bin/bash
fcomp=$1
fmode=$2
fopt=``
fdevel=``
    if [ "$fcomp" == 'ifort' ]; then
	fopt='-fast -parallel -qopenmp -fno-alias -m64 -simd -qoffload-arch=ivybridge'
	if [ "$fmode" == 'devel' ]; then
	    fdevel='-CB'	    
	fi
    elif [ "$fcomp" == 'gfortran' ]; then
	fopt='-O3'
	if [ "$fmode" == 'devel' ]; then
	    fdevel='-fbounds-check'	    
	fi
    else
	echo './build.sh [ifort or gfortran]'
	exit 1
    fi	
$fcomp -c $fopt $fdevel mod/values.f90
$fcomp -c $fopt $fdevel mod/*.f90
$fcomp  $fopt $fdevel main.f90 mod/*.f90 -o wien_filter
rm *.o
rm *.mod
