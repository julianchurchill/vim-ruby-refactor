require 'robot-vim'

Given /^a ruby source buffer in vim with the following content:$/ do |buffer_content|
  @vim_robot = RobotVim::Runner.new( :vimrc => "features/support/.vimrc" )
  @buffer_content = buffer_content
end

def run_vim_commands commands
  response = @vim_robot.run( :input_file => @buffer_content, :commands => commands )
  @buffer_content = response.body
end

When /^I visually highlight "(.*?)"$/ do |text_to_highlight|
  commands = <<-COMMANDS
/#{text_to_highlight}
v#{text_to_highlight.size}l
COMMANDS
  run_vim_commands commands
end

When /^I call the vim function "(.*?)"$/ do |function|
  @vim_function_to_call = "ExtractMethod"
end

When /^I supply the argument "(.*?)"$/ do |argument|
  commands = <<-COMMANDS
:call #{@vim_function_to_call}()
#{argument}
COMMANDS
  run_vim_commands commands
end

Then /^the buffer should contain:$/ do |expected_content|
  @buffer_content.should == expected_content
end

