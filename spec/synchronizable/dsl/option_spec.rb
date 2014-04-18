require 'spec_helper'

describe Synchronizable::DSL::Option do
  subject { HasOptions }

  it { respond_to? :foo }
  it { respond_to? :bar }
  it { respond_to? :baz }

  its(:foo) { should be nil }
  its(:bar) { should eq(1)  }
  its(:baz) { should eq(2)  }
end
