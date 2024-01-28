@list:
	just --list

stow pkg:
	stow --target "${HOME}" "{{pkg}}"


stow-etc pkg:
	sudo stow --target "/etc" "{{pkg}}"	

nixos-rebuild:
	sudo nixos-rebuild switch

darwin-deploy:
	nix build nix/darwin#darwinConfigurations.bri-macbook.system \
	   --extra-experimental-features "nix-command flakes"

	./result/sw/bin/darwin-rebuild switch --flake nix/darwin#bri-macbook
