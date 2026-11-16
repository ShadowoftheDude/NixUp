
function input
    read -p '' -c argv[1] argv[2]
end

gh auth login

input 'Repository: ' repo

input 'Target Path: ' path

gh repo clone $repo $path

input 'Host Name: ' host

nixos-rebuild switch --flake "$path#$host" --experimental-features 'nix-command flakes'

input 'Relative Host Path: ' rela

cp /etc/nixos/hardware-configuration.nix $path/$rela/_hw.nix
