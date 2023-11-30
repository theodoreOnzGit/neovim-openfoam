#!/bin/bash
#
# check if WM_PROJDIR has been set
# check if the foam source file has been set


if test -z "$WM_PROJECT_DIR"
then 
	openfoam_env_set=false
	echo "openfoam env not set"
else 
	openfoam_env_set=true
	# source it again to be safe
	source $WM_PROJECT_DIR/etc/bashrc
	echo "openfoam env set"

fi

echo "copy_nvimconfig_to_openfoam: copies the nvim config files
to openfoam"

copy_nvimconfig_to_openfoam() {
	rm $WM_PROJECT_DIR/foam-init.lua
	rm -r $WM_PROJECT_DIR/lua
	cp foam-init.lua $WM_PROJECT_DIR
	cp -r ./lua/ $WM_PROJECT_DIR
}

nvfoam() {
	nvim -u $WM_PROJECT_DIR/foam-init.lua $WM_PROJECT_DIR
}

if $openfoam_env_set 
then
	copy_nvimconfig_to_openfoam
	echo "nvim ready for use, just type nvfoam"
fi
