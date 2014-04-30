require 'spec_helper'
require 'pry-byebug'

describe Synchronizable::DSL::Macro do
  describe 'commom attributes' do
    subject { HasMacro }

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

  describe 'attribute with default value lambda that raises an error' do
    it 'raises error' do
      expect { HasMacro.carefull }.to raise_error(NotImplementedError)
    end

    context 'when overriden in subclass not to raise an error' do
      subject { HasMacroSubclass }

      it { respond_to? :foo }
      it { respond_to? :bar }

      its(:foo) { should be nil  }
      its(:bar) { should eq(1)   }

      it 'not raises error' do
        expect { HasMacroSubclass.carefull }.to_not raise_error
      end

      it 'equals to the new default value' do
        expect(HasMacroSubclass.carefull).to eq(0)
      end
    end
  end

  describe 'methods' do
    subject { HasMacroSubclass }

    it { respond_to? :sqr }
    its(:sqr) { respond_to? :call }

    it "sqr method definition returns square of two numbers" do
      expect(subject.sqr.(2)).to eq(4)
    end
  end
end
