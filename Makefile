install:
	sudo nixos-rebuild switch --flake .

remote:
	rsync -aAXv --delete --exclude .git ./ nix-server:~/nix/ > /dev/null
	ssh nix-server "cd ~/nix && make install"
