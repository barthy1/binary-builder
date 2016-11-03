# encoding: utf-8
require 'spec_helper'

describe 'building a binary', :integration do
  context 'when nginx is specified' do
    before(:all) do
      run_binary_builder('nginx', '1.10.2', '--gpg-rsa-key-id=A1C052F8 --gpg-signature="-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYBjoRAAoJEFIKmZOhwFL4ScQH+wfGY2GnqHvgC0erte1lUtSA
bOKYrHsNE/kGkkIXpIy8ksYyfIf93NRhBjT55ZGhnEgIuYeqMSZhqxQUet4JCrU/
H+g7yb3oFtV1Uwv/5ALnsXsOHdGSvAUj/QFxyiwYOLDxK/riajMcELv/3Dh4fKTr
N4TS9stXXjYl0s57iGbJUe0ov+UX4GTVQqKqLRYSsmuyCBtVofUoEzOQz9rR/7RZ
3l6sAI2b/WgtkHpxsMxt45UMq8HuhwZLcae3qW+o/DadyBfT1oXCTfoePI644AaQ
S9fs2WNJLRMUyb1djRzU5CfwgYGmuAwJDjYuFp1cclpGKyxp8g0vPxnEQWAD8hI=
=imev
-----END PGP SIGNATURE-----"')
      @platform = (ENV['BINARY_BUILDER_PLATFORM'] == 'x86_64') ? "x64" : ENV['BINARY_BUILDER_PLATFORM']
      @binary_tarball_location = File.join(Dir.pwd, "nginx-1.10.2-linux-#{@platform}.tgz")
    end

    after(:all) do
      FileUtils.rm(@binary_tarball_location)
    end

    it 'builds the specified binary, tars it, and places it in your current working directory' do
      expect(File).to exist(@binary_tarball_location)

      httpd_version_cmd = "./spec/assets/binary-exerciser.sh nginx-1.10.2-linux-#{@platform}.tgz ./nginx/sbin/nginx -v"
      output, status = run(httpd_version_cmd)

      expect(status).to be_success
      expect(output).to include('1.10.2')
    end
  end
end
