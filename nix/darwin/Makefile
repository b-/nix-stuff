.PHONY: all
all: build deploy

.PHONY: build
build:
	nix build .#darwinConfigurations.bri-macbook.system \
	   --extra-experimental-features "nix-command flakes"
#deploy: build
.PHONY: deploy
deploy:
	./result/sw/bin/darwin-rebuild switch --flake .#bri-macbook
