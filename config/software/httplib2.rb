name "httplib2"
default_version "0.9"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/jcgregorio/httplib2/master/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
