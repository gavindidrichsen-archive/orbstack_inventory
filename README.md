# orbstack_inventory

## Description

This plugin module enables dynamic orbstack bolt inventory.  It is modeled after the "Reference" plugins described in the bolt documentation [here](https://www.puppet.com/docs/bolt/latest/writing_plugins.html#reference-plugins).

## Design Decisions

<!-- adrlog -->

* [ADR-0001](doc/adr/0001-extract-task-logic-into-lib-directory.md) - Extract task logic into 'lib' directory
* [ADR-0002](doc/adr/0002-assume-that-native-ssh-is-configured-so-command-line-ssh-connects-fine-to-orbstack.md) - Assume that native ssh is configured so command-line ssh connects fine to orbstack

<!-- adrlogstop -->

## Usage

* update your `bolt-project.yaml` to include the `orbstack_inventory` dynamic inventory plugin, something like:

  ```yaml
  ---
  name: bigbird
  modules:
    - git: 'https://github.com/gavindidrichsen-puppetlabs/orbstack_inventory.git'
      ref: main
  ```

* `bolt module install` to download the plugin locally.
* update your `inventory.yaml` to look like:

  ```yaml
  ---
  version: 2
  groups:
    - name: orbstack
      targets:
        _plugin: orbstack_inventory
  ```

* verify it's working by first adding some VMs to your local orbstack and then running `bolt inventory show`.  The output should show the current list of VMs, something like:

  ```bash
  gavin.didrichsen@DEV-Didrichsen bigbird % /opt/puppetlabs/bin/bolt inventory show
  Targets
    20.04
    22-04
    24-04
    fedora-poo
    gitea
    httpgitea
    rocky-clean-amd
    rocky9amd
    rocky9arm
  ...
  ...
  ```

## Contributing

If making a change to code warrants more explanation, then consider adding a separate design decision document or `ADR`.  See more information [here](https://github.com/gavindidrichsen-puppetlabs/practices/blob/main/docs/adr/0001-record-architecture-decisions.md)
