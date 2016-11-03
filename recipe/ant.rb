# encoding: utf-8
require_relative 'base'

class AntRecipe < BaseRecipe
  def url
    "https://www.apache.org/dist/ant/source/apache-ant-#{version}-src.tar.gz"
  end

  def cook
    download unless downloaded?
    extract
    install
  end

  def install
    FileUtils.mkdir_p(path)
    platform = ppc64le? ? "ppc64el" : "amd64"
    execute('install', [
              'env',
              "JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-#{platform}/",
              "ANT_HOME=#{path}",
              'sh', 'build.sh', 'install-lite'
            ])
  end
end
