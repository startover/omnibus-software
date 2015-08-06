name "golang"
default_version "1.4.2"

# Windows only DSL to install Go on the system, under C:\golang

if ohai['kernel']['machine'] == 'x86_64'
  source :url => "https://storage.googleapis.com/golang/go#{version}.windows-386.msi",
         :md5 => '020502bc282115a2290aac77b2079530'
else
  source :url => "https://storage.googleapis.com/golang/go#{version}.windows-amd64.msi",
         :md5 => '020502bc282115a2290aac77b2079530'
end

build do
    command "start /wait msiexec /x go#{version}.windows-amd64.msi /qn"
    command "start /wait msiexec /i go#{version}.windows-amd64.msi INSTALLDIR=\""\
        "C:\\golang_omnibus\" /qn"
end
