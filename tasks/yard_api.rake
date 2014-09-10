require 'fileutils'
require 'yard-api/yardoc_task'

runner = YARD::APIPlugin::YardocTask.new

desc 'generate YARD API docs'
task :yard_api => :environment do |t|
  output = runner.config['output']
  puts <<-Message
    API Documentation successfully generated in #{output}
    See #{output}/index.html
  Message
end