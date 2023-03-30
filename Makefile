install:
	sudo nixos-rebuild switch --flake .#server

remote:
	rsync -aAXv --delete . nix-server:~/dotfiles > /dev/null
	ssh nix-server "cd ~/dotfiles && sudo nixos-rebuild switch --flake ."
