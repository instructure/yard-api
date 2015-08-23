desc 'generate YARD API docs'
task :yard_api => :environment do |t|
  require 'fileutils'
  require 'yard-api/yardoc_task'

  runner = YARD::APIPlugin::YardocTask.new
  output = runner.config['output']

  puts case runner.config['format']
  when 'html'
    <<-Message
      API documentation (in HTML format) was successfully generated.
      Open #{output}/index.html in a browser.
    Message
  when 'json'
    <<-Message
      API documentation (in JSON format) was successfully generated.
      You will find the documents in #{output}/*.json
    Message
  end
end