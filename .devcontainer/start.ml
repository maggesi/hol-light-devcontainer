loadt "/workspaces/hol-light-devcontainer/.devcontainer/psearch.ml";;
loadt "/workspaces/hol-light-devcontainer/.devcontainer/more_tactics.ml";;
unset_verbose_symbols();;
loadt "update_database.ml";;
Gc.compact()
