#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "curl"
default_version "7.41.0"

if ohai['platform'] != 'windows'

  source :url => "http://curl.haxx.se/download/curl-#{version}.tar.gz",
         :md5 => '7321a0a3012f8eede729b5a44ebef5bd'

  dependency "zlib"
  dependency "openssl"

  relative_path "curl-#{version}"

  build do
    ship_license "https://raw.githubusercontent.com/bagder/curl/master/COPYING"
    block do
      FileUtils.rm_rf(File.join(project_dir, 'src/tool_hugehelp.c'))
    end

    command ["./configure",
             "--prefix=#{install_dir}/embedded",
             "--disable-manual",
             "--disable-debug",
             "--enable-optimize",
             "--disable-ldap",
             "--disable-ldaps",
             "--disable-rtsp",
             "--enable-proxy",
             "--disable-dependency-tracking",
             "--enable-ipv6",
             "--without-libidn",
             "--without-gnutls",
             "--without-librtmp",
             "--with-ssl=#{install_dir}/embedded",
             "--with-zlib=#{install_dir}/embedded"].join(" ")

    command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
    command "make install"
  end

else
  # Compiling is hard... let's ship binaries instead : TODO: react according to platform
  source :url => "https://s3.amazonaws.com/dd-agent-omnibus/curl4-7.43.0.tar.gz",
         :md5 => 'add6d8b80d02903c77d3d9dfe5ef1e03'

  relative_path "curl"

  build do
    ship_license "https://raw.githubusercontent.com/bagder/curl/master/COPYING"

    copy 'cygcurl-4.dll', "#{install_dir}/embedded/Lib/cygcurl.dll"
  end
end
