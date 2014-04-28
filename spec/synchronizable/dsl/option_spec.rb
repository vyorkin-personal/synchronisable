require 'spec_helper'

describe Synchronizable::DSL::Options do
  describe 'commom options' do
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

  describe 'option with default value lambda that raises an error' do
    it 'raises error' do
      expect { HasOptions.carefull }.to raise_error(NotImplementedError)
    end

    context 'when overriden in subclass not to raise an error' do
      subject { HasOptionsSubclass }

      it { respond_to? :foo }
      it { respond_to? :bar }

      its(:foo) { should be nil  }
      its(:bar) { should eq(1)   }

      it 'not raises error' do
        expect { HasOptionsSubclass.carefull }.to_not raise_error
      end

      it 'equals to the new default value' do
        expect(HasOptionsSubclass.carefull).to eq(0)
      end
    end
  end
end
