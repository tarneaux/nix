install:
	sudo nixos-rebuild switch --flake .

remote:
	rsync -aAXv --delete --exclude .git . nix-server:~/dotfiles > /dev/null
	ssh nix-server "cd ~/dotfiles && make install"
