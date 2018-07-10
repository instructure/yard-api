namespace :doc do
  desc 'Generate docs for Bridge API controllers.'
  task 'api' => :environment do |t|
    require 'yard-api'
    require 'yard-api/yardoc_task'

    runner = YARD::APIPlugin::YardocTask.new(:api_docs)
    Rake::Task['api_docs'].invoke

    puts <<-Message
      API documentation (in HTML format) was successfully generated.
      Please open "#{runner.config['output']}/index.html" with a web browser.
    Message
  end
end
