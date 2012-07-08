require 'robot-vim'

Given /^a ruby source buffer in vim with the following content:$/ do |buffer_content|
  @vim_robot = RobotVim::Runner.new
  @buffer_content = buffer_content
end

When /^I visually highlight "(.*?)"$/ do |text_to_highlight|
  commands = <<-COMMANDS
    /#{text_to_highlight}
    v#{text_to_highlight.size}l
  COMMANDS
  @vim_robot.run( :input_file => @buffer_content, :commands => commands )
end

When /^I call the vim function ":ExtractMethod"$/ do
  pending
end

When /^I supply the argument "test_equality"$/ do
  pending
end

Then /^the buffer should contain:$/ do
  pending
end


