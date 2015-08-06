name "datadog-gohai"
default_version "last-stable"

if ohai['platform'] == 'windows'
  # We don't have Go installed by default on our build box because it would be a bit dirty to
  # include it in the Vagrant box (which is supposed to be as lightweight and clean as possible)
  # and we can't do it during provisiong because there's no golang chef recipe for windows
  # This DSL will install Go on the system (but it won't be shipped with the agent ofc)
  dependency "golang"

  build do
    command "cmd /C \"SET GOPATH=\"#{cache_dir}\\src\\#{name}\" && "\
            "#{gobin} get -d -u github.com/DataDog/gohai\" && "\
            "CHDIR #{cache_dir}\\src\\#{name}\\src\\github.com\\Datadog\\gohai && "\
            "git checkout #{default-version} && git pull && "\
            "#{gobin} build -o #{install_dir}\\bin\\gohai.exe gohai.go"
  end
else
  env = {
    "GOROOT" => "/usr/local/go",
    "GOPATH" => "#{cache_dir}/src/#{name}"
  }

  if ohai['platform_family'] == 'mac_os_x'
    env.delete "GOROOT"
    gobin = "/usr/local/bin/go"
  else
    gobin = "/usr/local/go/bin/go"
  end

  build do
     ship_license "https://raw.githubusercontent.com/DataDog/gohai/master/LICENSE"
     command "#{gobin} get -d -u github.com/DataDog/gohai", :env => env
     command "git checkout #{default_version} && git pull", :env => env, :cwd => "#{env['GOPATH']}/src/github.com/DataDog/gohai"
     command "#{gobin} build -o #{install_dir}/bin/gohai $GOPATH/src/github.com/DataDog/gohai/gohai.go", :env => env
  end
end
