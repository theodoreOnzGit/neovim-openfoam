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

#echo "copy_nvimconfig_to_openfoam: copies the nvim config files
#to openfoam"

copy_nvimconfig_to_openfoam() {
	rm $WM_PROJECT_DIR/foam-init.lua
	rm -r $WM_PROJECT_DIR/lua
	cp foam-init.lua $WM_PROJECT_DIR
	cp -r ./lua/ $WM_PROJECT_DIR
}


if $openfoam_env_set 
then
	copy_nvimconfig_to_openfoam
	nvfoam() {
		cd $WM_PROJECT_DIR && nvim -u $WM_PROJECT_DIR/foam-init.lua $WM_PROJECT_DIR/README.md
	}
	echo "use nvfoam to start neovim in openfoam environment"
fi
