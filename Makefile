install:
	nixos-rebuild switch --flake .#server-test

remote:
	echo "Copying files to nix-server-test..."
	rsync -aAXv --delete . nix-server-test:~/dotfiles > /dev/null
	echo "Done."
	ssh nix-server-test "cd ~/dotfiles && make install"
