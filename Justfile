nixos_flake := "./nix/nixos#chromebook-nixos"
darwin_flake := "./nix/darwin#darwinConfigurations.bri-macbook.system"

@list:
	just --list

# collect garbage
gc:
	sudo nix-collect-garbage -d

# stow dotfiles
stow pkg:
	stow --target "${HOME}" "{{pkg}}"

# stow to etc
stow-etc pkg:
	sudo stow --target "/etc" "{{pkg}}"
# deploy flake to nixos
nixos-rebuild:
	sudo nixos-rebuild switch --flake "{{nixos_flake}}" --upgrade-all

# deploy flake to darwin
darwin-deploy:
	cd nix/darwin && make deploy
	# nix build nix/darwin#darwinConfigurations.bri-macbook.system \
	#    --extra-experimental-features "nix-command flakes"

	# ./result/sw/bin/darwin-rebuild switch --flake nix/darwin#bri-macbook
