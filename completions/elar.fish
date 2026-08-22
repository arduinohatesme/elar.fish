set -l plugin_dir (path dirname (path dirname (status filename)))

complete -c elar -n __fish_use_subcommand -a "sentence vocab root"
complete -c elar -n "__fish_seen_subcommand_from vocab sentence" -a '(
    set -l plugin_dir '$plugin_dir'
    path basename (path change-extension "" $plugin_dir/data/vocab/*.json ~/.config/elar/vocab/*.json) 2>/dev/null | sort -u
)'
complete -c elar -n "__fish_seen_subcommand_from root" -a '(
    set -l plugin_dir '$plugin_dir'
    path basename (path change-extension "" $plugin_dir/data/roots/*.json ~/.config/elar/roots/*.json) 2>/dev/null | sort -u
)'
