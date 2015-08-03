name "procps-ng"
default_version "3.3.9"

if ohai['platform'] != 'windows'

  dependency 'ncurses'

  source :url => "http://dd-agent-omnibus.s3.amazonaws.com/#{name}-#{version}.tar.xz",
         :md5 => '0980646fa25e0be58f7afb6b98f79d74'

  relative_path "procps-ng-3.3.9"

  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
  }

  build do
    ship_source "http://dd-accgent-omnibus.s3.amazonaws.com/#{name}-#{version}.tar.xz"
    ship_license "https://gitlab.com/procps-ng/procps/raw/master/COPYING"
    command(["./configure",
       "--prefix=#{install_dir}/embedded",
       ""].join(" "),
    :env => env)
    command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
    command "make install"
    move "#{install_dir}/embedded/usr/bin/*", "#{install_dir}/embedded/bin/"
    delete "#{install_dir}/embedded/usr/bin"
  end

else
  # We create a dummy file for the omnibus git_cache to work on Windows
  build do
    command "touch #{install_dir}/uselessfile"
  end
end
