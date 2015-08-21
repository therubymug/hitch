# Add the following to your ~/.bashrc or ~/.zshrc
#
# Alternatively, copy/symlink this file and source in your shell.  See `hitch --setup-path`.

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
  if [[ -s "$HOME/.hitch_ssh_keys" ]] ; then source "$HOME/.hitch_ssh_keys"; fi
}
alias unhitch='hitch -u'

# Uncomment to persist pair info between terminal instances
# hitch
