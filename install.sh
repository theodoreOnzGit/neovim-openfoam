#!/bin/bash
#
# check if WM_PROJDIR has been set
# check if the foam source file has been set

if test -z "$WM_PROJECT_DIR"
then 
	echo "openfoam env not set"
else 
	echo "openfoam env set"
fi
