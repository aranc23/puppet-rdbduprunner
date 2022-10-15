# @summary used by rdbduprunner to install the software
class rdbduprunner::install
(
)
{
  ensure_packages($rdbduprunner::packages)
}
