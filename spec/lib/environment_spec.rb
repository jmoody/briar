describe Briar::Environment do

  let(:variable_name) {'BRIAR_RSPEC_TEST_VARIABLE'}

  before(:each) {
    ENV.delete(variable_name)
  }

  describe '.variable' do
    it 'returns value of environment variable' do
      ENV[variable_name] = 'foo'
      expect(Briar::Environment.variable(variable_name)).to be == 'foo'
    end
  end

  describe '.set_variable' do
    it 'can set value of environment variable' do
      expect(ENV[variable_name]).to be == nil
      Briar::Environment.set_variable(variable_name, 'foo')
      expect(ENV[variable_name]).to be == 'foo'
    end
  end
end
