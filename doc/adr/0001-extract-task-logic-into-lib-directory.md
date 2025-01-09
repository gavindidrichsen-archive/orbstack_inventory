# 1. Extract task logic into 'lib' directory

Date: 2025-01-09

## Status

Accepted

## Context

At it's most basic level, a bolt task can include all necessary logic in the same file.  For example, the `tasks/resolve_reference.rb` task could simply contain all the logic to parse the orbstack VM's and return the inventory object.  However, this is not a ruby best practice as code should normally be kept beneath the `lib` directory.

The only problem is that a basic task will not have access to the `lib` directory on the target machine unless the task metadata is updated to "share" the `lib`.  The [sharing task code](https://www.puppet.com/docs/bolt/latest/writing_tasks#sharing-task-code) documentation explains how to ensure bolt ships extra files and directories required for the operation of a task.

## Decision

Therefore, I decided to move all ruby logic beneath the `lib` directory and share the `lib` with the task on the target server.  For more information see the [appendix](#keypoints-for-sharing-code-with-tasks).

## Consequences

Now I can treat the code as simple ruby and, of course, test it with rspec.  In other words, I don't have to do any special to test the task itself because the ruby code will be tested via the `spec` tests.

## Appendix

### Keypoints for sharing code with tasks

There are a few key points to achieving this:

* Ensure the task metadata "shares" the necessary files or directories.  For example, my `orbstack_inventory/tasks/resolve_reference.json` metadata added the `lib` directory as follows:

```json
{
  "description": "Resolve targets for Orbstack inventory",
  "input_method": "stdin",
  "files": ["orbstack_inventory/lib/"],
  "parameters": {}
}
```

* Include the `lib` code in the task.  One way to do this is with a `require_relative` as follows:

```ruby
require 'json'
params = JSON.parse(STDIN.read)
installdir = params['_installdir']

require_relative File.join(params['_installdir'], 'orbstack_inventory', 'lib', 'orbstack_inventory.rb')
```

Another way is to load the `lib` directory onto the ruby path, e.g.,

```ruby
params = JSON.parse(STDIN.read)                                 # Read the input from Bolt
installdir = params['_installdir']                              # metaparameter received by default from bolt
lib_path = File.join(installdir, 'orbstack_inventory', 'lib')   
$LOAD_PATH.unshift(lib_path)                                    # Add the lib directory to the load path

require 'orbstack_inventory'
```
