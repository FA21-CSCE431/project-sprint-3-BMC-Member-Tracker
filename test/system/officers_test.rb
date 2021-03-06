# frozen_string_literal: true

require 'application_system_test_case'

class OfficersTest < ApplicationSystemTestCase
  before do
    @officer = officers(:one)
  end

  test 'visiting the index' do
    visit officers_url
    assert_selector 'h1', text: 'Officers'
  end

  test 'creating a Officer' do
    visit officers_url
    click_on 'New Officer'

    fill_in 'Amountowed', with: @officer.amountOwed
    fill_in 'Email', with: @officer.email
    fill_in 'Name', with: @officer.name
    fill_in 'Officeruin', with: @officer.officerUIN
    click_on 'Create Officer'

    assert_text 'Officer was successfully created'
    click_on 'Back'
  end

  test 'updating a Officer' do
    visit officers_url
    click_on 'Edit', match: :first

    fill_in 'Amountowed', with: @officer.amountOwed
    fill_in 'Email', with: @officer.email
    fill_in 'Name', with: @officer.name
    fill_in 'Officeruin', with: @officer.officerUIN
    click_on 'Update Officer'

    assert_text 'Officer was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Officer' do
    visit officers_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Officer was successfully destroyed'
  end
end
