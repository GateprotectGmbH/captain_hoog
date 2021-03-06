module CaptainHoog
  class PluginList

    attr_reader :plugins

    def initialize(type='pre-commit', config: {})
      @config = config
      @type   = type
      build_list
    end

    def has?(plugin)
      @plugins.include?(plugin.plugin_name)
    end

    private

    def build_list
      plugins_for_type = @config.fetch(@type, [])
      excluded_plugins = @config.fetch('exclude', [])

      plugins_for_type = [] if plugins_for_type.nil?
      excluded_plugins = [] if excluded_plugins.nil?

      @plugins = plugins_for_type - excluded_plugins
    end

  end
end
