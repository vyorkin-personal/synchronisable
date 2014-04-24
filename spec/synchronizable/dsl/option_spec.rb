require 'spec_helper'

describe Synchronizable::DSL::Option do
  subject { HasOptions }

  before do
    subject.xyz 7
    subject.arr 1, 2, 3
  end

  it { respond_to? :foo }
  it { respond_to? :bar }
  it { respond_to? :baz }
  it { respond_to? :xxx }
  it { respond_to? :arr }

  its(:foo) { should be nil  }
  its(:bar) { should eq(1)   }
  its(:baz) { should eq(2)   }
  its(:xyz) { should eq('7') }
  its(:arr) { should eq([1, 2, 3]) }
end
