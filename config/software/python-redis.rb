name "python-redis"
default_version "2.10.3"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/andymccurdy/redis-py/master/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" redis==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" redis==#{version}"
  end
end
