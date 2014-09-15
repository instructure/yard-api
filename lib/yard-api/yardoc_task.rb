require 'fileutils'

module YARD::APIPlugin
  class YardocTask < ::YARD::Rake::YardocTask
    attr_reader :config

    def initialize(name=:yard_api)
      super(name, &:run)
    end

    def run
      YARD::APIPlugin.options.reset_defaults

      @config = load_config
      t = self

      YARD::APIPlugin.options.update(@config)

      t.verifier = YARD::APIPlugin::Verifier.new(config['verbose'])
      t.before = proc { FileUtils.rm_rf(config['output']) }
      t.files = config['files']

      config['debug'] ||= ENV['DEBUG']
      config['verbose'] ||= ENV['VERBOSE']

      set_option('template', 'api')
      set_option('no-yardopts')
      set_option('no-document')

      set_option('markup', config['markup']) if config['markup']
      set_option('markup-provider', config['markup_provider']) if config['markup_provider']

      if config['markup_provider'] == 'redcarpet'
        require 'yard-api/markup/redcarpet'
      end

      set_option('title', config['title'])
      set_option('output-dir', config['output'])
      set_option('one-file') if config['one_file']
      set_option('readme', config['readme']) if File.exists?(config['readme'])
      set_option('verbose') if config['verbose']
      set_option('debug') if config['debug']

      get_assets(config).each_pair do |asset_id, rpath|
        asset_path = File.join(config['source'], rpath)

        if File.directory?(asset_path)
          set_option 'asset', [ asset_path, asset_id ].join(':')
        elsif config['strict']
          raise <<-Error
            Expected assets of type "#{asset_id}" to be found within
            "#{asset_path}", but they are not.
          Error
        end
      end

      if config['debug']
        puts "Invoking YARD with options: #{self.options.to_json}"
      end
    end

    private

    def load_config
      path = Rails.root.join('config', 'yard_api.yml')

      # load defaults
      config = YAML.load_file(File.join(YARD::APIPlugin::CONFIG_PATH, 'yard_api.yml'))
      config.merge!(YAML.load_file(path)) if File.exists?(path)
      config
    end

    def set_option(k, *vals)
      self.options.concat(["--#{k}", *vals])
    end

    def get_assets(config)
      config['assets'] || {}
    end
  end
end