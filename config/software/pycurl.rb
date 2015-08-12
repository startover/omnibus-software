name "pycurl"
default_version "7.19.5.1"

dependency "python"
dependency "pip"

if ohai['platform'] != "windows"
  dependency "curl"
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
    source :url => "http://www.lfd.uci.edu/~gohlke/pythonlibs/3i673h27/pycurl-7.19.5.1-cp35-none-win_amd64.whl",
           :md5 => '7d92e4be99f1c31d7cc42315c110aa20'

    relative_path "pycurl-#{version}"

    # God bless the maintainers of that website, god bless their families and children over
    # a thousand generation and, of course, Gog bless the United States of America
    command "#{install_dir}/embedded/Scripts/pip install pycurl-7.19.5.1-cp35-none-win_amd64.whl"
    # command "#{install_dir}/embedded/python setup.py --use-libcurl-dll --curl-dir="\
    #         "#{install_dir}/embedded/ --libcurl-lib-name=cygcurl.dll --avoid-stdio"
    # command "SET PYCURL_SETUP_OPTIONS=\"--avoid-stdio --use-libcurl-dll --curl-dir="\
    #         "#{install_dir}/embedded/Lib --libcurl-lib-name=cygcurl.dll\" & "\
    #         "#{install_dir}/embedded/Scripts/pip install -I #{name}==#{version}"
  end
end
