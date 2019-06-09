require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase

  test "visiting the index when logged out" do
    visit projects_url
    assert_selector "h2", text: "Log in"
  end

  test "visiting the index when logged in" do
    visit projects_url
    assert_selector "h2", text: "My Projects"
  end

end
