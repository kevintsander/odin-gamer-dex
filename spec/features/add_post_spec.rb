require 'rails_helper'

RSpec.describe 'Adding a post', type: :system do
  let(:body) { Faker::Lorem.characters(number: 200) }
  it 'valid text input' do
    user = FactoryBot.create(:user)
    login_as user
    visit user_path(user)
    fill_in 'post[body]', with: body
    click_on 'add-post'

    expect(find('.post-body > p', text: body))
  end
end
