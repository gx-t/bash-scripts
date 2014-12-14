#!/usr/bin/env bash

check-user-password() {
        local password
        read uid && read password && cd 2> /dev/null "$uid" && [[ "$password" == $(cat ".password") ]] && return 0
        echo "Authorization failed"
	return 1
}

echo-line() {
	echo "OK"
	cat
}

register() {
	local password
	local uid
	read password && (( ${#password} < 5 )) && echo "ERR" && echo "Password must be at least 5 characters long" && return 
	uid=$(uuidgen)
	mkdir "$uid" && cd "$uid" && mkdir "inbox" && echo "$password" > ".password" && cat > .info && echo "OK" && echo "$uid"
}

login() {
	check-user-password || return
	cd "inbox" && echo "OK" && ls | while read ff
	do
		echo "message"
		ls -l $ff | awk '{print $5}'
		cat "$ff"
	done
}

message() {
	local dest
	check-user-password || return
	read dest && cd 2> /dev/null "../$dest" && cd "inbox" && cat > "msg-$(uuidgen)" && echo "OK" && return
	echo "ERR"
	echo "Error registering message. Invalid user id?"
}

cd users || exit 1

printf "\n\n"
read cmd
[[ "$cmd" == "echo-line" || "$cmd" == "register" || "$cmd" == "login" || "$cmd" == "message" ]] && "$cmd"

