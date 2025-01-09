#!/usr/bin/env ruby

require 'json'
require 'yaml'

# Define the OrbstackInventory class here
class OrbstackInventory
  def initialize(config = {})
    @config = config
  end

  # This method is called by Bolt to fetch inventory data
  def resolve_reference(_opts = {})
    orbs = fetch_orbstack_vms
    generate_inventory(orbs)
  end

  private

  # Fetch Orbstack VM details using the CLI
  def fetch_orbstack_vms
    JSON.parse(`orb list --format json`)
  end

  # Generate the Bolt inventory structure
  def generate_inventory(orbs)
    {
      'value' => orbs.map do |orb|
        {
          'name' => orb['name'],
          'uri' => "#{orb['name']}@orb",
          'config' => {
            'transport' => 'ssh',
            'ssh' => {
              'native-ssh' => true,
              'load-config' => true,
              'login-shell' => 'bash',
              'tty' => false,
              'host-key-check' => false,
              'run-as' => 'root',
              'user' => 'root',
              'port' => 32_222
            }
          }
        }
      end
    }
  end
end
