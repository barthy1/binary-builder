# encoding: utf-8
require 'spec_helper'
require 'fileutils'

describe 'building a binary', :integration do
  context 'when node is specified' do
    before(:all) do
      @platform = (ENV['BINARY_BUILDER_PLATFORM'] == 'x86_64') ? "x64" : ENV['BINARY_BUILDER_PLATFORM']
      sha256 = @platform == 'ppc64le' ? "b92c2588ccab61f6be3c8457e41f6d9067b08e2d1649c4616396a9083641967a" : "ac7e78ade93e633e7ed628532bb8e650caba0c9c33af33581957f3382e2a772d"
      run_binary_builder('node', '4.6.0', "--sha256=#{sha256}")

      @binary_tarball_location = File.join(Dir.pwd, "node-4.6.0-linux-#{@platform}.tgz")
    end

    after(:all) do
      FileUtils.rm(@binary_tarball_location)
    end

    it 'builds the specified binary, tars it, and places it in your current working directory' do
      expect(File).to exist(@binary_tarball_location)

      node_version_cmd = "./spec/assets/binary-exerciser.sh node-4.6.0-linux-#{@platform}.tgz node-v4.6.0-linux-#{@platform}/bin/node -e 'console.log(process.version)'"
      output, status = run(node_version_cmd)

      expect(status).to be_success
      expect(output).to include('v4.6.0')
    end
  end
end
