# orbstack_inventory

## Description

This plugin module enables dynamic orbstack bolt inventory.  It is modeled after the "Reference" plugins described in the bolt documentation [here](https://www.puppet.com/docs/bolt/latest/writing_plugins.html#reference-plugins).

## Design Decisions

<!-- adrlog -->

* [ADR-0001](doc/adr/0001-extract-task-logic-into-lib-directory-to-follow-ruby-best-practice.md) - Extract task logic into 'lib' directory to follow ruby best practice
* [ADR-0002](doc/adr/0002-configure-bolt-inventory-with-native-ssh-to-keep-things-simple.md) - Configure bolt inventory with native ssh to keep things simple
* [ADR-0003](doc/adr/0003-gather-inventory-metadata-via-the-orb-cli-to-keep-things-simple.md) - Gather inventory metadata via the 'orb' cli to keep things simple

<!-- adrlogstop -->

## Prerequisites

* orbstack is installed and that you have 1 or more VMs created.
* you are working in a bolt project.

## Usage

* add `https://github.com/gavindidrichsen-puppetlabs/orbstack_inventory.git` as a module to your `bolt-project.yaml`, e.g.,

  ```yaml
  modules:
    - git: https://github.com/gavindidrichsen-puppetlabs/orbstack_inventory.git
      ref: main
  ```

* install the module via `bolt module install`
* update your `inventory.yaml` to look something like:

  ```yaml
  version: 2
  groups:
    - name: orbstack
      targets:
        _plugin: orbstack_inventory
  ```

* verify your inventory via`bolt inventory show`.

## Contributing

If making a change to code warrants more explanation, then consider adding a separate design decision document or `ADR`.  See more information [here](https://github.com/gavindidrichsen-puppetlabs/practices/blob/main/docs/adr/0001-record-architecture-decisions.md)
