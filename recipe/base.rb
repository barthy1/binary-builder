# encoding: utf-8
require 'mini_portile'
require 'tmpdir'
require 'fileutils'
require_relative 'determine_checksum'
require_relative '../lib/yaml_presenter'

class BaseRecipe < MiniPortile
  def initialize(name, version, options = {})
    super name, version

    options.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    @arch = RbConfig::CONFIG['host_cpu']

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
    platform = ppc64le? ? "ppc64le" : "x64"
    "#{name}-#{version}-linux-#{platform}.tgz"
  end

  def archive_files
    []
  end

  def archive_path_name
    ''
  end

  def ppc64le?
    @arch == 'powerpc64le'
  end

  def x86_64?
    @arch == 'x86_64'
  end

  private

  # NOTE: https://www.virtualbox.org/ticket/10085
  def tmp_path
    "/tmp/#{@host}/ports/#{@name}/#{@version}"
  end
end
