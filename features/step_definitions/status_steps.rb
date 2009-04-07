Before do
  Setting.stubs(:gravatar_enabled?).returns(true)
end

Given /^I am logged in$/ do
  @current_user = Factory.create(:user)
  User.stubs(:current).returns(@current_user)
end

Given /^I am a member of a project$/ do
  @project = Factory.create(:project)
  Factory.create(:member, :project => @project, :user => @current_user)
end


Given /^I am on the Status page for the project$/ do
  unless @project
    @project = Factory.create(:project)
  end
  
  visit url_for(:controller => 'statuses', :action => 'index', :id => @project.id)
end

Given /^there are "(.*)" statuses$/ do |number|
  number.to_i.times do
    Factory.create(:status, :project => @project)
  end
end



Then /^I should see "(.*)" updates$/ do |count|
  response.should have_tag("dd.status_message", :count => count.to_i)
end

Then /^I should see "(.*)" Gravatar images$/ do |count|
  response.should have_tag("img.gravatar", :count => count.to_i)
end
