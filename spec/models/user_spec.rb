require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#find_relationship' do
    subject(:user) { FactoryBot.create(:user, id: 4142) }

    context 'id is greater than other_user_id' do
      let(:other_user) { FactoryBot.create(:user, id: 2552) }
      let(:good_relationship) { FactoryBot.create(:user_relationship, user:, friend: other_user) }
      let(:relationships) { double('relationships') }

      before do
        allow(user).to receive(:relationships).and_return(relationships)
        allow(relationships).to receive(:where).with(user_id: other_user.id).and_return([good_relationship])
      end

      it 'returns relationships with other user in user_id field' do
        find_result = user.find_relationship(other_user.id)
        expect(find_result).to eq(good_relationship)
      end
    end

    context 'id is less than than other_user_id' do
      let(:other_user) { FactoryBot.create(:user, id: 8250) }
      let(:good_relationship) { FactoryBot.create(:user_relationship, user: other_user, friend: user) }
      let(:relationships) { double('relationships') }

      before do
        allow(user).to receive(:relationships).and_return(relationships)
        allow(relationships).to receive(:where).with(friend_id: other_user.id).and_return([good_relationship])
      end

      it 'returns relationships with other user in user_id field' do
        find_result = user.find_relationship(other_user.id)
        expect(find_result).to eq(good_relationship)
      end
    end
  end
end
