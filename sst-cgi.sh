#!/usr/bin/env bash

check-user-password() {
	local password
	read uid && read password && cd 2> /dev/null "$uid" && [[ "$password" == `cat ".password"` ]] && echo "$uid" && return 0
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
	mkdir "$uid" && cd "$uid" && mkdir "inbox" && mkdir "contacts" && mkdir "reverse" && echo "$password" > ".password" && cat > .info && echo "OK" && echo "$uid"
}

login() {
	local uid
	uid=`check-user-password` || return
	cd "$uid/inbox" && echo "OK" && ls | while read ff
	do
		echo "message"
		ls -l $ff | awk '{print $5}'
		cat "$ff" && rm "$ff"
	done
}

message() {
	local uid
	local dest
	local msg
	uid=`check-user-password` || return
	msg="msg-$(uuidgen)"
	read dest && cd "$dest/inbox" 2> /dev/null && tmp=`tempfile` && echo "$uid" > "$tmp" && cat >> "$tmp" && mv "$tmp" "$msg" && echo "OK" && return
	echo "ERR"
	echo "Error registering message. Invalid user id?"
}

add-contact() {
	local uid
	local uid1
	uid=`check-user-password` || return
	read uid1 && ln -s "../../$uid1" "$uid/contacts/$uid1" && ln -s "../../$uid" "$uid1/reverse/$uid" && echo "OK" && return
	echo "ERR"
	echo "Error adding to contact list. Invalid user id?"
}

remove-contact() {
	local uid
	local uid1
	uid=`check-user-password` || return
	read uid1 && rm "$uid/contacts/$uid1" && rm "$uid1/reverse/$uid" && echo "OK" && return
	echo "ERR"
	echo "Error removing contact from list. Invalid user id?"
}

cd users || exit 1

printf "\n\n"
read cmd
[[ "$cmd" == "echo-line" ||
	"$cmd" == "register" ||
	"$cmd" == "login" ||
	"$cmd" == "message" ||
	"$cmd" == "add-contact" ||
	"$cmd" == "remove-contact" ]] && "$cmd"

