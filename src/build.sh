#! /bin/bash
fcomp=$1
fmode=$2
fopt=``
fdevel=``
    if [ "$fcomp" == 'ifort' ]; then
	#fopt='-fast -parallel -openmp -par-report=3' #devel
	fopt='-fast -parallel  -fno-alias -m64 -simd -qoffload-arch=ivybridge -qopt-report=2'
	if [ "$fmode" == 'devel' ]; then
	    fdevel='-qopenmp'	    
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
