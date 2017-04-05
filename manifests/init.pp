# Class: mavenfixed
# ===========================
#
# Full description of class mavenfixed here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'mavenfixed':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class maven { #Maven Class
  $maven_home = "/usr/lib/maven"
  $maven_archive = "apache-maven-3.3.9-bin.tar.gz"
  $maven_folder = "apache-maven-3.3.9"

  exec{'get_maven':
  command => "/usr/bin/wget -q http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz  -O /tmp/apache-maven-3.3.9-bin.tar.gz",
}


  Exec {
      path => [ "/usr/bin", "/bin", "/usr/sbin"]
  }


file { "/tmp/apache-maven-3.3.9-bin.tar.gz":
      ensure => file,
      source => 'puppet:///modules/maven/apache-maven-bin.tar.gz',
      owner => root,
      mode => '0755',
           require => Exec["get_maven"],
  }


  exec { 'extrac_ maven',
      cwd => "/tmp",
      command => "tar -xfv /tmp/apache-maven-3.3.9-bin.tar.gz",
      creates => "${maven_home}",
      require => File["/tmp/$maven_archive"]
  }

  exec { 'move_maven',
      command => "mv ${maven_folder} ${maven_home}",
      creates => "${maven_home}",
      cwd => cd "/tmp",
      require => Exec["extract maven"]
  }

  file { "/etc/profile.d/maven.sh":
      content =>  "export MAVEN_HOME=${maven_home}
                   export M2=\$MAVEN_HOME/bin
                   export PATH=\$PATH:\$M2
                   export MAVEN_OPTS=\"-Xmx512m -Xms512m\""
  }

  exec { 'maven_shell'

  }
}
