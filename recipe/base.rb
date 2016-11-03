# encoding: utf-8
require 'mini_portile'
require 'tmpdir'
require 'fileutils'
require_relative 'determine_checksum'
require_relative '../lib/yaml_presenter'

class BaseRecipe < MiniPortile
  def initialize(name, version, platform = 'x86_64', os = 'linux-gnu', options = {})
    super name, version
    options.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    puts "platform = #{platform}"
    @platform = platform
    puts "os = #{os}"
    @os = os

    @files = [{
      url: url
    }.merge(DetermineChecksum.new(options).to_h)]
  end

  def configure_options
    []
  end

  def compile
    execute('compile', [make_cmd, '-j4'])
  end

  def archive_filename
    puts "archive_filename platform_short= #{platform_short}"
    "#{name}-#{version}-linux-#{platform_short}.tgz"
  end

  def archive_files
    []
  end

  def archive_path_name
    ''
  end

  def ppc64le?
    @platform == 'ppc64le'
  end

  def x86_64?
    @platform == 'x86_64'
  end

  def platform_short
    platform_map = { 'x86_64' => 'x64',
                     'ppc64le' => 'ppc64le'}
    platform_map[@platform]
  end

  def supported?
    true
  end

  def source_directory
    platform_map = { 'x86_64' => 'x86_64',
                     'ppc64le' => 'powerpc64le'}

    "#{platform_map[@platform]}-#{@os}/"
  end

  private

  # NOTE: https://www.virtualbox.org/ticket/10085
  def tmp_path
    "/tmp/#{@host}/ports/#{@name}/#{@version}"
  end
end
