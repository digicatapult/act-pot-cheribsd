# shellcheck shell=sh

pot() {
  case $1 in
    help)                   fn='pot_help';;
    version)                fn='pot_version';;
    config)                 fn='pot_config';;
    ls|list)                fn='pot_list';;
    show)                   fn='pot_show';;
    info)                   fn='pot_info';;
    top)                    fn='pot_top';;
    ps)                     fn='pot_ps';;
    init)                   fn='pot_init';;
    de-init)                fn='pot_de_init';;
    vnet-start)             fn='pot_vnet_start';;
    create-base)            fn='pot_create_base';;
    create-fscomp)          fn='pot_create_fscomp';;
    create-private-bridge)  fn='pot_create_private_bridge';;
    create)                 fn='pot_create';;
    clone)                  fn='pot_clone';;
    clone-fscomp)           fn='pot_clone_fscomp';;
    rename)                 fn='pot_rename';;
    destroy)                fn='pot_destroy';;
    prune)                  fn='pot_prune';;
    copy-in)                fn='pot_copy_in';;
    copy-out)               fn='pot_copy_out';;
    mount-in)               fn='pot_mount_in';;
    mount-out)              fn='pot_mount_out';;
    add-dep)                fn='pot_add_dep';;
    set-rss)                fn='pot_set_rss';;
    get-rss)                fn='pot_get_rss';;
    set-cmd)                fn='pot_set_cmd';;
    set-env)                fn='pot_set_env';;
    set-hosts)              fn='pot_set_hosts';;
    set-hook)               fn='pot_set_hook';;
    set-attribute|set-attr) fn='pot_set_attribute';;
    get-attribute|get-attr) fn='pot_get_attribute';;
    export-ports)           fn='pot_export_ports';;
    start)                  fn='pot_start';;
    stop)                   fn='pot_stop';;
    term)                   fn='pot_term';;
    run)                    fn='pot_run';;
    snap|snapshot)          fn='pot_snapshot';;
    rollback|revert)        fn='pot_revert';;
    purge-snapshots)        fn='pot_purge_snapshots';;
    export)                 fn='pot_export';;
    import)                 fn='pot_import';;
    prepare)                fn='pot_prepare';;
    update-config)          fn='pot_update_config';;
    last-run-stats)         fn='pot_last_run_stats';;
    signal)                 fn='pot_signal';;
    exec)                   fn='pot_exec';;
    *)                      fn='pot_other';;
  esac
  shift 1
  if type "$fn" 2>/dev/null | grep -q 'function'; then
    $fn "$@"
  else
    :
  fi
}
