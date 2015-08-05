name "pyopenssl"
default_version "0.14"

if ohai['platform'] == 'windows'
  dependency "openssl-windows"
  dependency "python"
  dependency "pip"
  command "#{install_dir}/embedded/bin/pip install -I pyopenssl==#{version}"
else
  dependency "openssl"
  dependency "libffi"
  dependency "python"
  dependency "pip"

  build do
    ship_license "https://raw.githubusercontent.com/pyca/pyopenssl/master/LICENSE"
    build_env = {
      "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}",
      "LDFLAGS" => "-L/#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include/"
    }
    command "#{install_dir}/embedded/bin/pip install -I pyOpenSSL==#{version}", :env => build_env
  end
end
