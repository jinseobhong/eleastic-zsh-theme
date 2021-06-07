# !/bin/zsh
[[ ! -z $icons ]] && local icons
# Check current working directory's permission 
local pwd_owner_user pwd_owner_user_group
[[ -r $PWD ]] && icons+="r"
[[ -w $PWD ]] && icons+="w"
[[ -x $PWD ]] && icons+="x"
# If you current working directory's owner
pwd_owner_user=$(stat -c "%U" $PWD)
[[ $user == $pwd_owner_user ]] & pwd_owner_user=you
# Currnet working directory's group
pwd_owner_group=$(stat -c "%G" $PWD)