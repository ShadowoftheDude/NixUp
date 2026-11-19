
function input
    read -p '' -c $argv[1] $argv[2] || exit 1
end

set long (gh auth status 2>&1)
set test (string match -i -e "logged in" "$long")

if ! gh auth status &>/dev/null
    gh auth login
end

input 'Repository: ' repo

input 'Target Path: ' path

gh repo clone "$repo" "$path"

input 'Host Name: ' host

input 'Relative Path: ' rela

cp /etc/nixos/hardware-configuration.nix "$path"/"$rela"/_hw.nix

nixos-rebuild switch --flake "$path#$host" --experimental-features 'nix-command flakes'
