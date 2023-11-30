#!/bin/bash
#
# check if WM_PROJDIR has been set
# check if the foam source file has been set


if test -z "$WM_PROJECT_DIR"
then 
	openfoam_env_set=true
	echo "openfoam env not set"
else 
	openfoam_env_set=false
	echo "openfoam env set"
fi
