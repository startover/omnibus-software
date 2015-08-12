name "pycurl"
default_version "7.19.5.1"

dependency "python"
dependency "pip"
dependency "curl"

if ohai['platform'] != "windows"
  dependency "gdbm" if (ohai['platform'] == "mac_os_x" or ohai['platform'] == "freebsd" or ohai['platform'] == "aix")
  dependency "libgcc" if (ohai['platform'] == "solaris2" and Omnibus.config.solaris_compiler == "gcc")

  build do
    ship_license "https://raw.githubusercontent.com/pycurl/pycurl/master/COPYING-MIT"
    build_env = {
      "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}",
      # FIXME : eeeehm, shouldn't it rather be depending on the architecture of the build platform
      "ARCHFLAGS" => "-arch x86_64"
    }
    command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}", :env => build_env
  end
else
  build do
    source :url => "http://pycurl.sourceforge.net/download/pycurl-#{version}.tar.gz",
           :md5 => ''
    command "#{install_dir}/embedded/python setup.py --use-libcurl-dll --curl-dir=\""\
            "#{install_dir}/embedded/Lib\" --libcurl-lib-name=cygcurl.dll"
    # command "SET PYCURL_SETUP_OPTIONS=\"--avoid-stdio --use-libcurl-dll --curl-dir="\
    #         "#{install_dir}/embedded/Lib --libcurl-lib-name=cygcurl.dll\" & "\
    #         "#{install_dir}/embedded/Scripts/pip install -I #{name}==#{version}"
  end
end
