# encoding: utf-8
require 'mini_portile'
require 'fileutils'
require_relative 'base'

class NodeRecipe < BaseRecipe
  def computed_options
    options = [
      '--prefix=/'
    ]
      ppc64le? ? options.push('--dest-cpu=ppc64') : options
  end

  def install
    execute('install', [make_cmd, 'install', "DESTDIR=#{dest_dir}", 'PORTABLE=1'])
  end

  def archive_files
    [dest_dir]
  end

  def setup_tar
    FileUtils.cp(
      "#{work_path}/LICENSE",
      dest_dir
    )
  end

  # def cook
  #   puts "before download"
  #   download unless downloaded?
  #   puts "before extract"
  #   extract
  #   puts "before configure"
  #   configure
  #   puts "before install"
  #   install
  # end

  def url
    extension = version =~ /^(0.10)|(0.12)/ ? '-port' : ''
    ppc64le? ? "https://github.com/ibmruntimes/node/archive/v#{version}#{extension}.tar.gz" : "https://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"
  end

  def dest_dir
    "/tmp/node-v#{version}-linux-#{platform_short}"
  end

  def configure
    execute('configure', %w(python configure) + computed_options)
  end
end
