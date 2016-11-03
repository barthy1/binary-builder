# encoding: utf-8
require 'spec_helper'
require 'fileutils'

describe 'building a binary', :integration do
  context 'when node is specified' do
    before(:all) do
      sha256 = platform == 'ppc64le' ? "9dd0cb2ff1cb001687c78c5ed7f3d32abeb1e03bb28dea4238a2a0226f7cf9c6" : "ac7e78ade93e633e7ed628532bb8e650caba0c9c33af33581957f3382e2a772d"
      @version = platform == 'ppc64le' ? "4.6.1" : "0.12.2"
      run_binary_builder('node', @version, "--sha256=#{sha256} ")

      @binary_tarball_location = File.join(Dir.pwd, "node-#{@version}-linux-#{platform}.tgz")
    end

    after(:all) do
      FileUtils.rm(@binary_tarball_location)
    end

    it 'builds the specified binary, tars it, and places it in your current working directory' do
      expect(File).to exist(@binary_tarball_location)

      node_version_cmd = "./spec/assets/binary-exerciser.sh node-#{@version}-linux-#{platform_short}.tgz node-v#{@version}-linux-#{platform_short}/bin/node -e 'console.log(process.version)'"
      output, status = run(node_version_cmd)

      expect(status).to be_success
      expect(output).to include(@version)
    end
  end
end
