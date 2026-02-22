$env.CARAPACE_BRIDGES = 'zsh'

# Add Nix to PATH
$env.PATH = (
  $env.PATH
  | split row (char esep)
  | prepend '/run/current-system/sw/bin'
  | prepend '/nix/var/nix/profiles/default/bin'
  | prepend ($env.HOME + '/.nix-profile/bin')
)

# $env.ANTHROPIC_BASE_URL = "http://localhost:1234"
# $env.ANTHROPIC_API_KEY = "lmstudio"
