require 'spec_helper'

describe Synchronisable::DSL::Macro do
  describe 'commom attributes' do
    subject { HasMacroFoo }

    before do
      subject.xyz 7
      subject.arr 1, 2, 3
    end

    it { respond_to? :foo }
    it { respond_to? :bar }
    it { respond_to? :baz }
    it { respond_to? :xxx }
    it { respond_to? :arr }

    it { should_not respond_to? :baz }
    it { should_not respond_to? :sqr2 }

    its(:foo) { should be nil  }
    its(:bar) { should eq(1)   }
    its(:baz) { should eq(2)   }
    its(:xyz) { should eq('7') }
    its(:arr) { should eq([1, 2, 3]) }
  end

  describe 'attribute with default value lambda that raises an error' do
    it 'raises error' do
      expect { HasMacroFoo.carefull }.to raise_error(NotImplementedError)
    end

    context 'when overriden in subclass not to raise an error' do
      subject { HasMacroFooSubclass }

      it { should_not respond_to? :baz }
      it { should_not respond_to? :sqr2 }

      it { respond_to? :foo }
      it { respond_to? :bar }

      its(:foo) { should be nil  }
      its(:bar) { should eq(1)   }

      it 'not raises error' do
        expect { HasMacroFooSubclass.carefull }.to_not raise_error
      end

      it 'equals to the new default value' do
        expect(HasMacroFooSubclass.carefull).to eq(0)
      end
    end
  end

  describe 'methods' do
    subject { HasMacroFooSubclass }

    it { respond_to? :sqr }
    its(:sqr) { respond_to? :call }

    it "sqr method definition returns square of two numbers" do
      expect(subject.sqr.(2)).to eq(4)
    end
  end

  describe 'class attributes' do
    subject { HasMacroBar }

    it { should_not respond_to? :bar }
    it { should_not respond_to? :foo }
    it { should_not respond_to? :sqr }

    it { respond_to? :baz }
    it { respond_to? :sqr2 }
  end
end
