Facter.add("foreman_version") do
  setcode do
    foreman_path = "#{Facter[:boxen_home].value}/foreman/bin/foreman"
    if File.executable?(foreman_path)
      Facter::Util::Resolution.exec("#{foreman_path} version 2>&1")
    end
  end
end
