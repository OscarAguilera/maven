require 'spec_helper'
describe 'maven' do

  context 'with defaults for all parameters' do
    it { should contain_class('maven') }
  end
end
