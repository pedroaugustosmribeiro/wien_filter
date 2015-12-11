#! /bin/bash
fcomp=$1
fopt=``
    if [ "$fcomp" == 'ifort' ]; then
	fopt='-fast -CB -parallel -openmp' #-par-report=3' #devel
	#fopt='-fast -parallel -qopenmp -fno-alias -m64 -simd -qoffload-arch=ivybridge'
    elif [ "$fcomp" == 'gfortran' ]; then
	fopt='-fbounds-check -O3'
    else
	echo './build.sh [ifort or gfortran]'
	exit 1
    fi	
$fcomp -c $fopt mod/values.f90
$fcomp -c $fopt mod/*.f90
$fcomp  $fopt main.f90 mod/*.f90 -o wien_filter
rm *.o
rm *.mod
