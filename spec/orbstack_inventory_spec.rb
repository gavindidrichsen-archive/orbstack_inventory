# spec/unit/orbstack_inventory_spec.rb
require 'spec_helper'
require 'orbstack_inventory'

describe OrbstackInventory do
  let(:mock_orbs) do
    [
      { 'name' => 'agent01', 'status' => 'running' },
      { 'name' => 'agent02', 'status' => 'running' },
      { 'name' => 'compiler01', 'status' => 'running' },
      { 'name' => 'webserver01', 'status' => 'running' }
    ]
  end

  before(:each) do
    # Mock the orb list command
    allow_any_instance_of(OrbstackInventory).to receive(:fetch_orbstack_vms).and_return(mock_orbs)
  end

  context 'basic inventory without group_patterns' do
    let(:inventory) { OrbstackInventory.new }

    it 'generates inventory with only targets' do
      result = inventory.generate_inventory(mock_orbs)
      
      expect(result['value']['targets'].length).to eq(4)
      expect(result['value']['targets'].map { |t| t['name'] }).to contain_exactly(
        'agent01', 'agent02', 'compiler01', 'webserver01'
      )
      expect(result['value']).not_to have_key('groups')
    end
  end

  context 'inventory with matching group patterns' do
    let(:group_patterns) do
      {
        'group_patterns' => [
          { 'group' => 'agents', 'regex' => '^agent' },
          { 'group' => 'compilers', 'regex' => '^compiler' }
        ]
      }
    end
    let(:inventory) { OrbstackInventory.new(group_patterns) }

    it 'generates inventory with both groups' do
      result = inventory.generate_inventory(mock_orbs)
      
      expect(result['value']['groups'].length).to eq(2)
      
      agents_group = result['value']['groups'].find { |g| g['name'] == 'agents' }
      expect(agents_group['targets']).to contain_exactly('agent01', 'agent02')
      
      compilers_group = result['value']['groups'].find { |g| g['name'] == 'compilers' }
      expect(compilers_group['targets']).to contain_exactly('compiler01')
    end
  end

  context 'inventory with partially matching group patterns' do
    let(:group_patterns) do
      {
        'group_patterns' => [
          { 'group' => 'agents', 'regex' => '^agent' },
          { 'group' => 'databases', 'regex' => '^db' }  # Won't match any targets
        ]
      }
    end
    let(:inventory) { OrbstackInventory.new(group_patterns) }

    it 'generates inventory with only matching groups' do
      result = inventory.generate_inventory(mock_orbs)
      
      expect(result['value']['groups'].length).to eq(1)
      
      agents_group = result['value']['groups'].find { |g| g['name'] == 'agents' }
      expect(agents_group['targets']).to contain_exactly('agent01', 'agent02')
      
      expect(result['value']['groups'].none? { |g| g['name'] == 'databases' }).to be true
    end
  end

  context 'ssh configuration' do
    let(:inventory) { OrbstackInventory.new }

    it 'includes correct ssh configuration' do
      result = inventory.generate_inventory(mock_orbs)
      ssh_config = result['value']['config']['ssh']
      
      expect(ssh_config).to include(
        'native-ssh' => true,
        'load-config' => true,
        'login-shell' => 'bash',
        'tty' => false,
        'host-key-check' => false,
        'run-as' => 'root',
        'user' => 'root',
        'port' => 32_222
      )
    end
  end
end