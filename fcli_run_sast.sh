#!/usr/bin/env bash

# Dependencies:
#  - JDK 17
#  - fcli.jar 
#  - Maven or Gradle (this example uses Maven)
#  - scancentral executable

# Required Environment Variables:
# bamboo_ssc_applicationName='GSA/appsec-test' # Set this to your app name
# bamboo_release='fod_bamboo_testing' # This can be the name of the current branch
# FCLI_DEFAULT_FOD_URL='https://fed.fortifygov.com' # Use this as-is
# FCLI_DEFAULT_FOD_TENANT='GSAH' # Hybrid tenant
# FCLI_DEFAULT_FOD_USER=''
# FCLI_DEFAULT_FOD_PASSWORD=''

# Environment vars defined in external file:
# . ./env.sh

# Authenticate using env vars FCLI_DEFAULT_FOD_USER and FCLI_DEFAULT_FOD_PASSWORD (Personal Access Token)
java -jar ~/tools/fcli.jar fod session login

# Package
scancentral package -o package.zip --build-tool mvn 

# Create the release if it does not exist
java -jar ~/tools/fcli.jar fod action run setup-release --rel "${bamboo_ssc_applicationName}:${bamboo_release}" --scan-types sast --assessment-type "Static+"

# Scan
java -jar ~/tools/fcli.jar fod sast-scan start --rel "${bamboo_ssc_applicationName}:${bamboo_release}" -f package.zip --store fod_sast_scan

# Log out
java -jar ~/tools/fcli.jar fod session logout