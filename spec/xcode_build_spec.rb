require 'spec_helper'

describe XcTools::XcodeBuild do
  let(:output) { File.read(file) }

  context 'with settings output' do
    let(:file) { File.expand_path('../fixtures/xcodebuild-settings-output.txt', __FILE__) }

    describe '.settings' do
      before(:example) do
        expect(described_class)
          .to receive(:`)
          .with('xcodebuild -showBuildSettings -workspace "MegaProject.xcworkspace" -scheme "MegaProject" -configuration "Release" 2>&1')
          .and_return(output)
      end

      shared_examples 'settings behavior' do
        it 'returns settings' do
          expect(subject).to be_an(XcTools::XcodeBuild::Settings)
        end

        it 'is querable' do
          _, xcodebuild_settings = subject.find { |_, settings| settings['WRAPPER_EXTENSION'] == 'app' }

          expect(xcodebuild_settings['CONFIGURATION']).to eq('Release')
          expect(xcodebuild_settings['BUILT_PRODUCTS_DIR']).to eq('/Users/user/Library/Developer/Xcode/DerivedData/MegaProject-hnpshjktfnkgedbfccsjjlyytcgy/Build/Products/Release')
          expect(xcodebuild_settings['WRAPPER_NAME']).to eq('MegaProject.app')
          expect(xcodebuild_settings['WRAPPER_EXTENSION']).to eq('app')
        end

        describe '.find_app' do
          let(:app) { subject.find_app }

          it 'returns correct app' do
            expect(app['CONFIGURATION']).to eq('Release')
            expect(app['BUILT_PRODUCTS_DIR']).to eq('/Users/user/Library/Developer/Xcode/DerivedData/MegaProject-hnpshjktfnkgedbfccsjjlyytcgy/Build/Products/Release')
            expect(app['WRAPPER_NAME']).to eq('MegaProject.app')
            expect(app['WRAPPER_EXTENSION']).to eq('app')
          end
        end
      end

      context 'with array arguments' do
        let(:flags) do
          [
            '-workspace "MegaProject.xcworkspace"',
            '-scheme "MegaProject"',
            '-configuration "Release"'
          ]
        end

        subject { described_class.settings(*flags) }

        include_examples 'settings behavior'
      end

      context 'with hash argument' do
        let(:flags) do
          {
            workspace: "MegaProject.xcworkspace",
            scheme: "MegaProject",
            configuration: "Release"
          }
        end

        subject { described_class.settings(flags) }

        include_examples 'settings behavior'
      end
    end
  end

  context 'with info output' do
    let(:file) { File.expand_path('../fixtures/xcodebuild-info-output.txt', __FILE__) }

    describe '.info' do
      before(:example) do
        expect(described_class)
          .to receive(:`)
          .with('xcodebuild -list 2>&1')
          .and_return(output)
      end

      subject { described_class.info(workspace: nil) }

      it 'returns info object' do
        expect(subject).to be_an(XcTools::XcodeBuild::Info)
      end

      it 'returns correct info' do
        expect(subject.schemes).to eq(%w(MegaProject))
        expect(subject.targets).to eq(%w(MegaProject))
        expect(subject.build_configurations).to match_array(%w(Debug Release))
        expect(subject.project).to eq('MegaProject')
      end
    end
  end

  context 'with version output' do
    let(:output) { "Xcode 5.1.1\nBuild version 5B1008\n" }

    describe '.parse_xcode_version' do
      subject { described_class.parse_xcode_version(output) }

      it 'returns xcode version' do
        expect(subject).to eq('5.1.1')
      end
    end

    describe '.version' do
      before(:example) do
        expect(described_class)
          .to receive(:`)
          .with('xcodebuild -version')
          .and_return(output)
      end

      subject { described_class.version }

      it 'returns xcode version' do
        expect(subject).to eq('5.1.1')
      end
    end
  end
end
