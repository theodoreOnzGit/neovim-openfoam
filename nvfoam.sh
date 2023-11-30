#!/bin/bash
#
# check if WM_PROJDIR has been set
# check if the foam source file has been set


if test -z "$WM_PROJECT_DIR"
then 
	openfoam_env_set=false
	echo "please source the openfoam etc/bashrc file first"
else 
	openfoam_env_set=true
	# source it again to be safe
	source $WM_PROJECT_DIR/etc/bashrc
fi

if $openfoam_env_set 
then
	nvfoam() {
		cd $WM_PROJECT_DIR && nvim -u $WM_PROJECT_DIR/foam-init.lua $WM_PROJECT_DIR/README.md
	}
	echo "use nvfoam to start neovim in openfoam environment"
fi
nvfoam
