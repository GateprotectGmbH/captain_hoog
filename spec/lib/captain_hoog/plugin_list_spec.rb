require 'spec_helper'

describe CaptainHoog::PluginList do
  describe 'instance methods' do
    it 'provides #plugins method' do
      expect(described_class.new).to respond_to(:plugins)
    end

    it 'provides #has?' do
      expect(described_class.new).to respond_to(:has?)
    end

    describe '#plugins' do

      let(:plugin_dir_path) do
        File.join(File.dirname(__FILE__),
                  '..', '..',
                  'fixtures',
                  'plugins',
                  'test_plugins',
                  'passing')
      end

      let(:config) do
        {
          'exclude' => %w(mat git log),
          'pre-commit' => %w(rspec),
          'plugins_dir' => plugin_dir_path
        }
      end

      subject do
        described_class.new(config: config)
      end

      it 'returns available plugins' do
        expect(subject.plugins).to eq %w(rspec)
      end

    end
  end
end
