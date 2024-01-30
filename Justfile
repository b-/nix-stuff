nixos_flake := "./nix/nixos#chromebook-nixos"
darwin_flake := "./nix/darwin#darwinConfigurations.bri-macbook.system"

@list:
	just --list

stow pkg:
	stow --target "${HOME}" "{{pkg}}"


stow-etc pkg:
	sudo stow --target "/etc" "{{pkg}}"	

nixos-rebuild:
	sudo nixos-rebuild --flake 

darwin-deploy:
	cd nix/darwin && make deploy
	# nix build nix/darwin#darwinConfigurations.bri-macbook.system \
	#    --extra-experimental-features "nix-command flakes"

	# ./result/sw/bin/darwin-rebuild switch --flake nix/darwin#bri-macbook
