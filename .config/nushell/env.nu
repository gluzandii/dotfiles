$env.CARAPACE_BRIDGES = 'zsh'

# Add Nix to PATH
$env.PATH = (
  $env.PATH
  | split row (char esep)
  | prepend '/nix/var/nix/profiles/default/bin'
  | prepend ($env.HOME + '/.nix-profile/bin')
)
