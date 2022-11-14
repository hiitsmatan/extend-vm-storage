#!/bin/bash

check_free_space(){
    freespace=$(sudo vgdisplay | grep Free | awk {'print $7'})
    if [ -z "$freespace" ]; then
        freespace=0
    fi
}

extend_space() {
	lvvar=$(sudo lvdisplay | grep Path | awk {'print $3'})
	resizevar=$(df -h | grep -w / | awk {'print $1'})

	sudo lvextend -l +100%FREE $lvvar
	sudo resize2fs $resizevar
}

complete_func(){
    check_free_space
	echo "-----------------------------------"
	echo "RESIZE IS COMPLETE!!"
	echo "You have "$freespace" free space to extend"
	echo ""
}

check_free_space
if [ "$freespace" -ne "0" ]; then
    echo "-----------------------------------"
    echo "You have " $freespace " free space to extend"
    echo "-----------------------------------"
    echo ""
    while true; do
    	read -p "Do you want to extend? [Y/N]: " user_ans
    	case $user_ans in
    		[Yy]* ) extend_space && complete_func; break;;
    		[Nn]* ) exit;;
    		* ) echo "Please asnwer 'y' or 'n' ";;
    	esac
    done
else
    echo "-----------------------------------"
    echo "DONE, You had no free space to extend."
    echo "-----------------------------------"
    echo ""
fi
