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
    command "SET PYCURL_SETUP_OPTIONS=\"--avoid-stdio\" & "\
            "#{install_dir}/embedded/Scripts/pip install -I #{name}==#{version}"
  end
end
