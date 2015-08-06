name "tornado"
default_version "3.2.2"

dependency "python"
dependency "pip"
dependency "pycurl"
dependency "futures"

build do
  ship_license "https://raw.githubusercontent.com/tornadoweb/tornado/master/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
