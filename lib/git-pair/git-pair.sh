# Add the following to your ~/.bashrc or ~/.zshrc
#
# Alternatively, copy/symlink this file and source in your shell.  See `git pair --setup-path`.

pair() {
  command pair "$@"
  if [[ -s "$HOME/.git-pair_export_authors" ]] ; then source "$HOME/.git-pair_export_authors" ; fi
}

# Uncomment to persist pair info between terminal instances
# pair
