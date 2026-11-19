
function input
    read -p '' -c $argv[1] $argv[2]
end

gh auth status | string match -i 'logged in' | set loggedin

if $loggedin
    gh auth login
end

input 'Repository: ' repo

input 'Target Path: ' path

gh repo clone $repo $path

input 'Host Name: ' host

input 'Relative Path: ' rela

cp /etc/nixos/hardware-configuration.nix $path/$rela/_hw.nix

nixos-rebuild switch --flake "$path#$host" --experimental-features 'nix-command flakes'
