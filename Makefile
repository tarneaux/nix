install:
	sudo nixos-rebuild switch --flake .#server

remote:
	rsync -aAXv --delete . nix-server-test:~/dotfiles > /dev/null
	ssh nix-server-test "cd ~/dotfiles && make install"
