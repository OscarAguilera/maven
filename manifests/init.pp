class maven {
  $maven_home = "/usr/lib/maven"
  $maven_version ="3.3.9" 
  $maven_archive = "apache-maven-${maven_version}-bin.tar.gz"
  $maven_folder = "apache-maven-${maven_version}" 
  
  exec{'get_maven':
  command => "/usr/bin/wget -q http://redrockdigimark.com/apachemirror/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz  -O /tmp/apache-maven-${maven_version}-bin.tar.gz",
}


  Exec {
      path => [ "/usr/bin", "/bin", "/usr/sbin"]
  } 
  
  file { "/tmp/${maven_archive}":
      ensure => present,
      #source => "puppet:///modules/maven/${maven_archive}",
      owner => vagrant,
      mode => 755,
	   require => Exec["get_maven"],
  }
  
  exec { "extract maven":
      command => "tar xfv ${maven_archive}",
      cwd => "/tmp",
      creates => "${maven_home}",
      require => File["/tmp/${maven_archive}"]
  }

  exec { "move maven":
      command => "mv ${maven_folder} ${maven_home}",
      creates => "${maven_home}",
      cwd => "/tmp",
      require => Exec["extract maven"]
  }
  
  file { "/etc/profile.d/maven.sh":
      content =>   "export MAVEN_HOME=${maven_home}
                   export M2=\$MAVEN_HOME/bin
                   export PATH=\$PATH:\$M2
                   export MAVEN_OPTS=\"-Xmx512m -Xms512m\""
  }
}

