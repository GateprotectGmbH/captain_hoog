require 'spec_helper'

describe CaptainHoog::Test::Sandbox do
  let(:config) do
    {
      env: {
        suppress_headline: true
      }
    }
  end
  describe 'methods' do
    let(:null_plugin) do
      <<-PLUGIN
        git.describe 'null' do |hook|
          hook.run {}
        end
      PLUGIN
    end

    subject do
      described_class.new(null_plugin, config)
    end

    it 'provides #run' do
      expect(subject).to respond_to(:run)
    end

    it 'provides #configuration' do
      expect(subject).to respond_to(:configuration)
    end

    it 'provides #plugin' do
      expect(subject).to respond_to(:plugin)
    end
  end

  describe '#run' do
    context 'a plugin given as String' do

      let(:plugin) do
        <<-PLUGIN
          git.describe 'foo' do |hook|
            hook.helper :foo_helper do
              config.number
            end

            hook.test do
              foo_helper
              true
            end

            hook.message do
              'Fun'
            end
          end
        PLUGIN
      end

      let(:sandbox) do
        plugins_config = {
          plugin: {
            foo: {
              number: 12
            }
          }
        }
        cfg = config.merge(plugins_config)
        CaptainHoog::Test::Sandbox.new(plugin, cfg)
      end

      before do
        sandbox.run
      end

      it 'assigns evaluated plugin to #plugin' do
        expect(sandbox.plugin).to_not be nil
        expect(sandbox.plugin).to respond_to(:foo_helper)
        expect(sandbox.plugin.foo_helper).to eq 12
      end

      describe "#plugin" do
        it 'provides #result' do
          expect(sandbox.plugin).to respond_to(:result)
        end

        it 'provides access to helper' do
          expect(sandbox.plugin.foo_helper).to eq 12
        end

        describe '#result' do
          it 'has :test key' do
            expect(sandbox.plugin.result).to have_key(:test)
          end

          it 'has :message key' do
            expect(sandbox.plugin.result).to have_key(:message)
            expect(sandbox.plugin.result[:message]).to eq 'Fun'
          end
        end
      end
    end

    context 'a plugin given as file path' do
      let(:path) do
        File.expand_path(File.join(File.dirname(__FILE__),
                    "..",
                    "..",
                    "..",
                    "..",
                    "spec",
                    "fixtures",
                    "plugins",
                    "test_plugins",
                    "passing",
                    "simple",
                    "simple.rb"))
      end
      let(:sandbox) do
        plugin_config = {
          plugin: {
            simple: {
              runtime_count: 19.6
            }
          }
        }
        CaptainHoog::Test::Sandbox.new(File.new(path, 'r'),
                                       config.merge(plugin_config))
      end

      before do
        sandbox.run
      end

      it 'assigns evaluated plugin to #plugin' do
        expect(sandbox.plugin).to_not be nil
      end

      describe "#plugin" do
        it 'provides #result' do
          expect(sandbox.plugin).to respond_to(:result)
        end

        describe '#result' do
          it 'has :test key' do
            expect(sandbox.plugin.result).to have_key(:test)
            expect(sandbox.plugin.result[:test]).to be false
          end

          it 'has :message key' do
            expect(sandbox.plugin.result).to have_key(:message)
          end
        end
      end
    end

  end
end
