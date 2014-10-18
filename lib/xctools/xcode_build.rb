# based on source code from nomad/shenzhen project
# see https://github.com/nomad/shenzhen/blob/master/lib/shenzhen/xcodebuild.rb

require 'ostruct'

module XcTools
  module XcodeBuild
    Error = Class.new(StandardError)
    NilOutputError = Class.new(Error)

    Info = Class.new(OpenStruct)

    class Settings < Hash
      def initialize(hash = {})
        merge!(hash)
      end

      def find_app
        values.find { |settings| settings['WRAPPER_EXTENSION'] == 'app' }
      end
    end

    def self.info(*args)
      output = execute_xcodebuild('-list', *args)
      info = parse_info_output(output)
      Info.new(info)
    end

    def self.parse_info_output(output)
      lines = output.split(/\n/)

      project_name = parse_info_project_name(lines.first)

      info, _ = lines.drop(1).reduce([{}, nil]) do |(info, group), line|
        parse_info_line(line, info, group)
      end

      info.each do |_, values|
        values.delete('')
        values.uniq!
      end

      info.merge(project: project_name)
    end
    private_class_method :parse_info_output

    def self.parse_info_project_name(line)
      $1 if line =~ /\"(.+)\"\:/
    end
    private_class_method :parse_info_project_name

    def self.parse_info_line(line, info, group)
      if line =~ /\:$/
        group = line.strip[0...-1].downcase.gsub(/\s+/, '_')
        info[group] = []
      else
        info[group] << line.strip unless group.nil? || line =~ /\.$/
      end

      [info, group]
    end
    private_class_method :parse_info_line

    def self.settings(*args)
      output = execute_xcodebuild('-showBuildSettings', *args)
      settings = parse_settings_output(output)
      Settings.new(settings)
    end

    def self.parse_settings_output(output)
      lines = output.split(/\n/)

      lines.reduce([{}, nil]) do |(settings, target), line|
        parse_settings_line(line, settings, target)
      end.first
    end
    private_class_method :parse_settings_output

    def self.parse_settings_line(line, settings, target)
      case line
      when /Build settings for action build and target \"?([^":]+)/
        target = $1
        settings[target] = {}
      else
        key, value = line.split(/\=/).map(&:strip)
        settings[target][key] = value if target
      end

      [settings, target]
    end
    private_class_method :parse_settings_line

    def self.version
      output = `xcodebuild -version`
      parse_xcode_version(output)
    end

    def self.parse_xcode_version(output)
      $1 if output =~ /([\d+\.?]+)/
    end

    def self.execute_xcodebuild(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      cmd_args = (args + args_from_options(options)).join(' ')
      output = `xcodebuild #{cmd_args} 2>&1`
      fail Error, $1 if output =~ /^xcodebuild\: error\: (.+)$/
      fail NilOutputError unless output =~ /\S/

      output
    end
    private_class_method :execute_xcodebuild

    def self.args_from_options(options = {})
      options
        .reject { |_, value| value.nil? }
        .map { |key, value| "-#{key} \"#{value}\"" }
    end
    private_class_method :args_from_options
  end
end
