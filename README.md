# orbstack_inventory

## Description

## Design Decisions

<!-- adrlog -->

* [ADR-0001](doc/adr/0001-extract-task-logic-into-lib-directory.md) - Extract task logic into 'lib' directory

<!-- adrlogstop -->

## Usage

Clone this repository beneath your bolt project's root directory, e.g., `./modules/orbstack_inventory`

Update your `inventory.yaml` to look like:

```yaml
---
version: 2
groups:
  - name: orbstack
    targets:
      _plugin: orbstack_inventory
```

Verify it's working by running `bolt inventory show`

## Contributing

If making a change to code warrants more explanation, then consider adding a separate design decision document or `ADR`.  See more information [here](https://github.com/gavindidrichsen-puppetlabs/practices/blob/main/docs/adr/0001-record-architecture-decisions.md)
