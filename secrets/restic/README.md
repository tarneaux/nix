# Restic

Article: https://www.arthurkoziel.com/restic-backups-b2-nixos/

## Adding a host

Add the host with the server public key (from `/etc/ssh/ssh_host_ed25519_key.pub`) to the secrets.nix file.

After generating Backblaze app credentials, run:
```sh
agenix -e restic/<HOST>/env.age
```
Put in:
```sh
B2_ACCOUNT_ID="my-id"
B2_ACCOUNT_KEY="my-key"
```

Generate a new password. Save it somewhere else! Put it in `restic/<HOST>/password.age`.

Also enter the bucket name in the format `b2:my-bucket-name` in `restic/<HOST>/repo.age`.
