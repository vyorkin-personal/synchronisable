require 'spec_helper'

describe Synchronizable::DSL::Option do
  subject { HasOptions }

  before do
    subject.xyz 7
  end

  it { respond_to? :foo }
  it { respond_to? :bar }
  it { respond_to? :baz }
  it { respond_to? :xxx }

  its(:foo) { should be nil  }
  its(:bar) { should eq(1)   }
  its(:baz) { should eq(2)   }
  its(:xyz) { should eq('7') }
end
