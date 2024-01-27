@list:
	just --list

stow pkg:
	stow --target "${HOME}" "{{pkg}}"


stow-etc pkg:
	sudo stow --target "/etc" "{{pkg}}"	

nixos-rebuild:
	sudo nixos-rebuild switch
