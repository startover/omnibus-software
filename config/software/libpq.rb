name "libpq"
default_version "9.4.0"

source :url => "http://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.gz",
       :md5 => "349552802c809c4e8b09d8045a437787"

if ohai['platform'] != 'windows'

  dependency "zlib"
  dependency "openssl"
  dependency "libedit"
  dependency "ncurses"

  relative_path "postgresql-#{version}"

  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
  }


  build do
    ship_license "https://raw.githubusercontent.com/lpsmith/postgresql-libpq/master/LICENSE"
    command [ "./configure",
              "--prefix=#{install_dir}/embedded",
              "--with-libedit-preferred",
              "--with-openssl",
              "--with-includes=#{install_dir}/embedded/include",
              "--with-libraries=#{install_dir}/embedded/lib" ].join(" "), :env => env
    command "make -j #{workers}", :env => { "LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
    mkdir "#{install_dir}/embedded/include/postgresql"
    command "make -C src/include install"
    command "make -C src/interfaces install"
    command "make -C src/bin/pg_config install"
  end

else
  # We create a dummy file for the omnibus git_cache to work on Windows
  build do
    ship_license "https://raw.githubusercontent.com/lpsmith/postgresql-libpq/master/LICENSE"

    env = {
      "LDFLAGS" => "-L#{windows_safe_path(install_dir)}\\embedded\\lib -I#{windows_safe_path(install_dir)}\\embedded\\include",
      "CFLAGS" => "-L#{windows_safe_path(install_dir)}\\embedded\\lib -I#{windows_safe_path(install_dir)}\\embedded\\include",
      "LD_RUN_PATH" => "#{install_dir}\\embedded\\lib"
    }

    # make is actually shipped with chefdk... Pretty convenient isn't it ? As long as we build in a
    # chef provision machine we have it in our path, which is awesome. In case we want to change
    # at some point, we'll have to add a software definition that downloads and installs MinGW or
    # Cygwin to compile pg_config and libpq.
    command "bash -c 'ls -la .'"
    command "bash -c 'pwd'"
    command "pwd"
    command [ "bash -c './configure",
              "--prefix=#{install_dir}//embedded",
              "--with-libedit-preferred",
              "--with-openssl",
              "--with-includes=#{install_dir}/embedded/include",
              "--with-libraries=#{install_dir}/embedded/lib '" ].join(" "), :env => env
    command "make -j #{workers}", :env => { "LD_RUN_PATH" => "#{windows_safe_path(install_dir)}\\embedded\\lib"}
    mkdir "#{windows_safe_path(install_dir)}\\embedded\\include\\postgresql"
    command "make -C src\\include install"
    command "make -C src\\interfaces install"
    command "make -C src\\bin\\pg_config install"
  end
end
