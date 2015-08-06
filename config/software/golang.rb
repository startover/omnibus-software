name "golang"
default-version "1.4.2"

# Windows only DSL to install Go on the system, under C:\golang
# TODO: have a switch on the architecture

source :url => "https://storage.googleapis.com/golang/go#{version}.windows-amd64.msi",
       :md5 => ""

build do
    command "start /wait msiexec /x go#{version}.windows-amd64.msi /qn"
    command "start /wait msiexec /i go#{version}.windows-amd64.msi TARGETDIR=\""\
        "C:\\golang-omnibus\" /qn"

  #touch "#{install_dir}/uselessfile"
end
