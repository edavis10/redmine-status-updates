require File.dirname(__FILE__) + '/../spec_helper'

# Un-monkey patch GLoc's monkey patch of ActionView::Base
module ActionView
  class Base
    alias :initialize :initialize_without_gloc
  end
end

describe StatusesHelper, '#format_status_message' do
  include StatusesHelper

  it 'should use textilizable' do
    status = mock_model(Status, :message => 'Test', :has_hashtag? => false)
    self.should_receive(:textilizable).with(status.message).and_return('<p>Test</p>')

    format_status_message(status)
  end

  it 'should link any hash tags in the Status' do
    status = mock_model(Status, :message => 'Test #ruby', :has_hashtag? => true)
    textilized_status = '<p>Test #ruby</p>'
    
    self.stub!(:textilizable).and_return(textilized_status)
    self.should_receive(:link_hash_tags).with(textilized_status)

    format_status_message(status)
  end
end

describe StatusesHelper, "#link_hash_tags" do
  include StatusesHelper

  it 'with no hashtags should do nothing' do
    message = 'There are no Hashtags in here'
    link_hash_tags(message).should eql(message)
  end

  it 'with one hashtag should add one link' do
    response = link_hash_tags('There is one #tag')
    response.should have_tag('a[href=?]', url_for(:controller => 'statuses',
                                                  :action => 'tagged',
                                                  :tag => 'tag'))
  end

  it 'with two hashtags should add two links' do
    response = link_hash_tags('There is two tags #ruby #redmine')

    response.should have_tag('a[href=?]', url_for(:controller => 'statuses',
                                                  :action => 'tagged',
                                                  :tag => 'ruby'))
    response.should have_tag('a[href=?]', url_for(:controller => 'statuses',
                                                  :action => 'tagged',
                                                  :tag => 'redmine'))
  end
    
end