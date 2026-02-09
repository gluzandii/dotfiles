# ----------------------------
# PATH setup (converted from zsh)
# Put this in env.nu
# ----------------------------

def --env path-add [p: string] {
  let expanded = ($p | path expand)
  if ($expanded | path exists) {
    if not ($env.PATH | any { |x| $x == $expanded }) {
      $env.PATH = ($env.PATH | prepend $expanded)
    }
  }
}

# Homebrew LLVM
path-add "/opt/homebrew/opt/llvm@18/bin"
path-add "/opt/homebrew/bin"
path-add "/Users/sushi/.cargo/bin"

# Set Linker and Compiler Flags
$env.LDFLAGS = '-L/opt/homebrew/opt/llvm@18/lib'
$env.CPPFLAGS = '-I/opt/homebrew/opt/llvm@18/include'

# Set CMake Prefix Path
$env.CMAKE_PREFIX_PATH = '/opt/homebrew/opt/llvm@18'

# 1. CGO Flags
# We run llvm-config and trim the trailing newline
$env.CGO_CFLAGS = (llvm-config --cflags | str trim)
$env.CGO_LDFLAGS = (llvm-config --ldflags | str trim)

# 2. Pkg Config
# We use string interpolation to insert the brew path safely
$env.PKG_CONFIG_PATH = $"((brew --prefix llvm@18 | str trim))/lib/pkgconfig"

# 3. LLVM_SYS Prefix
# Crucial: For LLVM 18.1.8, the crate looks for '180'
$env.LLVM_SYS_180_PREFIX = (llvm-config --prefix | str trim)



# Go (your zsh used $(go env GOPATH)/bin and also $GOPATH/bin)
# Here: set GOPATH explicitly, then add GOPATH/bin
$env.GOPATH = "/Users/sushi/Dev/Go"
path-add $"($env.GOPATH)/bin"


let graal: string = (try { ^/usr/libexec/java_home | str trim } catch { "" })

if ($graal != "" and ($graal | path exists)) {
  $env.GRAALVM_HOME = $graal
  $env.JAVA_HOME = $graal
  $env.PATH = ($env.PATH | prepend $"($env.GRAALVM_HOME)/bin")
}

# Bun
# path-add "/Users/sushi/.bun/bin"

# Your scripts
path-add "/Users/sushi/scripts"

# Python user bin
path-add "/Users/sushi/Library/Python/3.9/bin"

# LM Studio
path-add "/Users/sushi/.lmstudio/bin"

# pnpm
$env.PNPM_HOME = "/Users/sushi/Library/pnpm"
path-add $env.PNPM_HOME

# local bin
path-add "/Users/sushi/.local/bin"
path-add "/usr/local/bin"

$env.config.edit_mode = "vi"
$env.config.buffer_editor = "/Users/sushi/.local/bin/lvim"
$env.config.show_banner = false
$env.RAVEDUDE_PORT = "/dev/cu.usbmodem2101"

source ./carapace/init.nu

use ./starship/init.nu

source ./zoxide/init.nu

source ./completions/zellij.nu

$env.config.keybindings = [
  {
    name: delete_word_backward
    modifier: alt
    keycode: backspace
    mode: [emacs, vi_insert, vi_normal]
    event: { edit: backspaceword }
  }
  {
    name: delete_line_to_start
    modifier: control
    keycode: char_u
    mode: [emacs, vi_insert, vi_normal]
    event: { edit: cutfromstart }
  }
]
alias less = bat
alias cat  = bat --paging=never
alias nvim = lvim
