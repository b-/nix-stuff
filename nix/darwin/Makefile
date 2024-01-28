deploy:
	nix build .#darwinConfigurations.bri-macbook.system \
	   --extra-experimental-features "nix-command flakes"

	./result/sw/bin/darwin-rebuild switch --flake .#bri-macbook
