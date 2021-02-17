require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'Associations' do
    it { should belong_to(:submitter) }
    it { should belong_to(:receiver) }
  end
end
