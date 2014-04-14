require 'spec_helper'

describe Synchronizable::DSL do
  context 'when local record does not exist' do
    let!(:remote_attrs) do
      [{
        :di     => 'xxx',
        :eman   => 'Konstantin',
        :ega    => 6,
        :thgiew => 44
      },
      {
        :di     => 'xxx',
        :eman   => 'Leonard',
        :ega    => 4,
        :thgiew => 37
      }]
    end

    subject { -> { Deer.sync(remote_attrs.first) } }

    it { should change { Deer.count }.by(1) }
    it { should change { Synchronizable::Import.count }.by(1) }

    context 'with existing local record' do
      let!(:leonard) { Deer.first }

      subject do
        -> {
          Deer.sync(remote_attrs.second)
          leonard.reload
        }
      end

      it { should change { leonard.name   }.from('Konstantin').to('Leonard') }
      it { should change { leonard.age    }.from(6).to(4) }
      it { should change { leonard.weight }.from(44).to(37) }
    end
  end
end
