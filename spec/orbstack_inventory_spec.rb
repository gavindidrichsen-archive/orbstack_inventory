require 'orbstack_inventory'

RSpec.describe OrbstackInventory do
  let(:inventory) { OrbstackInventory.new }

  describe '#resolve_reference' do
    it 'responds to resolve_reference' do
      expect(inventory).to respond_to(:resolve_reference)
    end
  end

  describe '#fetch_orbstack_vms' do
    it 'responds to fetch_orbstack_vms' do
      expect(inventory.send(:fetch_orbstack_vms)).to be_a(Array)
    end
  end

  describe '#generate_inventory' do
    it 'generates inventory structure' do
      orbs = [{ 'name' => 'test-orb' }]
      result = inventory.send(:generate_inventory, orbs)
      expect(result).to be_a(Hash)
      expect(result['value'].first['name']).to eq('test-orb')
    end
  end
end