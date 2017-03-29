#!/usr/bin/env bash

set -e
path="$(dirname "$0")"
source "$path/common.sh"

# Change to the Drupal Directory Just In Case
pushd "$DRUPAL_ROOT"
echo "drupal base: $DRUPAL_ROOT"
echo "drush in update.sh: $drush"

# This was added because of upgrades like Rules 2.8 to 2.9 and Feeds alpha-9 to beta-1 where
# new code and database tables are added and running other code will cause white screen until
# the updates are run.
echo "Initial Update so updated modules can work.";
$drush updb -y;
# Rebuild cache so recently added modules are found.
echo "Clearing cache.";
$drush $drush_cache_clear all
echo "Enabling modules.";
$drush en $(echo $DROPSHIP_SEEDS | tr ':' ' ') -y
echo "Enabling themes.";
$drush en $DEFAULT_THEME $ADMIN_THEME -y
echo "Clearing drush cache."
$drush $drush_cache_clear drush
if [ "$DRUPAL_VERSION" = 8 ]; then
  echo "Reverting configuration."
  $drush cim sync --partial -y
  if [ -e "$base/config/drupal/panels_pages" ]; then
    echo "Importing panels pages configuration."
    $drush cim panels_pages --partial -y
  fi
  if [ -e "$base/config/drupal/overrides" ]; then
    echo "Importing overrides configuration."
    $drush cim overrides --partial -y
  fi
  if [ "$SITE_ENVIRONMENT" = "test" ] && [ -e "$base/config/drupal/test" ]; then
    echo "Importing test configuration."
    $drush cim test --partial -y
  fi
  if [ "$SITE_ENVIRONMENT" = "dev" ] && [ -e "$base/config/drupal/dev" ]; then
    echo "Importing dev configuration."
    $drush cim dev --partial -y
  fi
fi
echo "Importing Features"
$drush fra -y
echo "Clearing caches one last time.";
$drush $drush_cache_clear all

chmod -R +w "$base/cnf"
chmod -R +w "$DRUPAL_ROOT/sites/default"
