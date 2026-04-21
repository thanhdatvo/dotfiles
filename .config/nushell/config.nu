$env.EDITOR = "nvim"


# START starship config
$env.STARSHIP_SHELL = "nu"
$env.STARSHIP_CONFIG = ($nu.home-path | path join ".config/starship.toml")
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
# END starship config
