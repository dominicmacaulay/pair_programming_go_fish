require_relative '../lib/confirmation_message'

RSpec.describe ConfirmationMessage do
  let(:confirmation_message1) { ConfirmationMessage.new('Random Input') }
  let(:confirmation_message2) { ConfirmationMessage.new('Random Input2') }
  let(:confirmation_message3) { ConfirmationMessage.new('Random Input') }
  describe '#display' do
    it 'should return that an input in acceptable' do
      expect(confirmation_message1.display).to eq "'#{confirmation_message1.input}' is... acceptable."
    end
  end

  describe '#==' do
    it 'should return false if other input is not equal to original input' do
      confirmation_message1 == confirmation_message2
    end

    it 'should return true if other input is the same as the original input' do
      confirmation_message1 == confirmation_message3
    end
  end
end
