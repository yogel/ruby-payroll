require "application_system_test_case"

class PayrollsTest < ApplicationSystemTestCase
  setup do
    @payroll = payrolls(:one)
  end

  test "visiting the index" do
    visit payrolls_url
    assert_selector "h1", text: "Payrolls"
  end

  test "should create payroll" do
    visit payrolls_url
    click_on "New payroll"

    fill_in "Amount", with: @payroll.amount
    fill_in "Cycle", with: @payroll.cycle
    click_on "Create Payroll"

    assert_text "Payroll was successfully created"
    click_on "Back"
  end

  test "should update Payroll" do
    visit payroll_url(@payroll)
    click_on "Edit this payroll", match: :first

    fill_in "Amount", with: @payroll.amount
    fill_in "Cycle", with: @payroll.cycle
    click_on "Update Payroll"

    assert_text "Payroll was successfully updated"
    click_on "Back"
  end

  test "should destroy Payroll" do
    visit payroll_url(@payroll)
    click_on "Destroy this payroll", match: :first

    assert_text "Payroll was successfully destroyed"
  end
end
