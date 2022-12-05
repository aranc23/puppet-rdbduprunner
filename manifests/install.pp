# @summary used by rdbduprunner to install the software
class rdbduprunner::install
(
)
{
  ensure_packages($rdbduprunner::package, { ensure => $rdbduprunner::package_ensure })
  ensure_packages($rdbduprunner::extra_packages)
}
