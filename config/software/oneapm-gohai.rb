name "oneapm-gohai"
default_version "last-stable"

env = {
  "GOROOT" => "/usr/local/go",
  "GOPATH" => "/var/cache/omnibus/src/oneapm-gohai"
}

if ohai['platform_family'] == 'mac_os_x'
  env.delete "GOROOT"
  gobin = "/usr/local/bin/go"
else
  gobin = "/usr/local/go/bin/go"
end

build do
   ship_license "https://raw.githubusercontent.com/startover/gohai/master/LICENSE"
   command "#{gobin} get -d -u github.com/startover/gohai", :env => env
   command "git checkout #{default_version} && git pull", :env => env, :cwd => "/var/cache/omnibus/src/oneapm-gohai/src/github.com/startover/gohai"
   command "#{gobin} build -o #{install_dir}/bin/gohai $GOPATH/src/github.com/startover/gohai/gohai.go", :env => env
end
