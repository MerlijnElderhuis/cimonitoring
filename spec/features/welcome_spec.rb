require 'rails_helper'

describe 'welcome' do
  it 'should show welcome' do
    visit '/welcome/greetings'
    expect(page).to have_content('Welcome')
  end
end
