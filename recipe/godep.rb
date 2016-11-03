# encoding: utf-8
require_relative 'base'

class GodepMeal < BaseRecipe
  attr_reader :name, :version

  def cook
    download unless downloaded?
    extract

    # Installs go 1.6.2 binary to /usr/local/go/bin
    Dir.chdir("/usr/local") do
      go_download = ppc64le? ? "http://ftp.unicamp.br/pub/ppc64el/ubuntu/14_04/cloud-foundry/go-1.6.2-ppc64le.tar.gz" : "https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz"

      go_tar = "go.tar.gz"
      system("curl -L #{go_download} -o #{go_tar}")
      system("tar xf #{go_tar}")
    end

    FileUtils.rm_rf("#{tmp_path}/godep")
    FileUtils.mv(Dir.glob("#{tmp_path}/godep-*").first, "#{tmp_path}/godep")
    Dir.chdir("#{tmp_path}/godep") do
      system(
        {"GOPATH" => "#{tmp_path}/godep/Godeps/_workspace:/tmp"},
        "/usr/local/go/bin/go get ./..."
      ) or raise "Could not install godep"
    end
    FileUtils.mv("#{tmp_path}/godep/License", "/tmp/License")
  end

  def archive_files
    ['/tmp/bin/godep', '/tmp/License']
  end

  def archive_path_name
    'bin'
  end

  def url
    "https://github.com/tools/godep/archive/#{version}.tar.gz"
  end

  def go_recipe
    @go_recipe ||= GoRecipe.new(@name, @version)
  end

  def tmp_path
    '/tmp/src/github.com/tools'
  end
end
