# orbstack_inventory

A Bolt inventory plugin that generates inventory from Orbstack VMs.

## Description

The `orbstack_inventory` plugin queries Orbstack for VMs and generates a Bolt inventory. It uses native SSH for connecting to the VMs and supports dynamic group creation based on target name patterns. It is modeled after the "Reference" plugins described in the bolt documentation [here](https://www.puppet.com/docs/bolt/latest/writing_plugins.html#reference-plugins).

## Prerequisites

* [Orbstack](https://orbstack.dev/) installed and configured
* `orb` cli command available in the PATH
* One or more orbstack VMs have been created.

## Getting Started

1. Add the `orbstack_inventory` module to your `bolt-project.yaml`.  For example:

  ```yaml
  # bolt-project.yaml
  ---
  name: bigbird
  modules:
    - git: https://github.com/gavindidrichsen-puppetlabs/orbstack_inventory.git
      ref: main
  ...
  ...
  ```

1. Create a basic inventory.yaml:

  ```yaml
  # inventory.yaml
  version: 2
  _plugin: orbstack_inventory
  ```

1. Verify your inventory:

  ```bash
  bolt inventory show
  ```

## How-to Guides

### How to add dynamic groups

To dynamically create groups based on target name patterns, add a `group_patterns` section to your `inventory.yaml`.  For example, the following will create 2 groups "agents" and "compilers" if VMs exist matching these patterns:

```yaml
version: 2
_plugin: orbstack_inventory
group_patterns:  # Optional: define groups based on target name patterns
  - group: agents
    regex: "^agent"
  - group: compilers
    regex: "^compiler"
```

Verify the groups:

```bash
bolt group show
bolt command run "hostname" --targets=agents
bolt command run "hostname" --targets=compilers
```

## Explanations

### Design Decisions

<!-- adrlog -->

* [ADR-0001](doc/adr/0001-extract-task-logic-into-lib-directory-to-follow-ruby-best-practice.md) - Extract bolt task logic into 'lib' directory to simplify rspect testing
* [ADR-0002](doc/adr/0002-configure-bolt-inventory-with-native-ssh-to-keep-things-simple.md) - Configure bolt inventory with native ssh to keep things simple
* [ADR-0003](doc/adr/0003-gather-inventory-metadata-via-the-orb-cli-to-keep-things-simple.md) - Gather inventory metadata via the 'orb' cli to keep things simple
* [ADR-0004](doc/adr/0004-create-dynamic-inventory-groups-based-on-hostname-regex-patterns.md) - Create dynamic inventory groups based on hostname regex patterns

<!-- adrlogstop -->

## Contributing

If making a change to code warrants more explanation, then consider adding a separate design decision document or `ADR`.  See more information [here](https://github.com/gavindidrichsen-puppetlabs/practices/blob/main/docs/adr/0001-record-architecture-decisions.md)
