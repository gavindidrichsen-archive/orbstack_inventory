#!/usr/bin/env ruby

require 'json'

params = JSON.parse(STDIN.read)                                 # Read the input from Bolt
installdir = params['_installdir']                              # metaparameter received by default from bolt
lib_path = File.join(installdir, 'orbstack_inventory', 'lib')
$LOAD_PATH.unshift(lib_path)                                    # Add the lib directory to the load path

require 'orbstack_inventory'

inventory = OrbstackInventory.new

# Call the resolve_reference method and output the result
begin
  result = inventory.resolve_reference
  puts result.to_json
rescue StandardError => e
  STDERR.puts({ _error: { msg: e.message, kind: 'bolt/plugin-error' } }.to_json)
  exit 1
end
