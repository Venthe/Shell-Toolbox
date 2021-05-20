# ## Offline/air-gapped installation[](https://docs.openproject.org/installation-and-operations/installation/docker/#offlineair-gapped-installation)

# It’s possible to run the docker image on an a system with no internet access using `docker save` and `docker load`. The installation works the same as described above. The only difference is that you don’t download the image the usual way.

# **1) Save the image**

# On a system that has access to the internet run the following.

#     docker pull openproject/community:11 && docker save openproject/community:11 | gzip > openproject-11.tar.gz
    

# This creates a compressed archive containing the latest OpenProject docker image. The file will have a size of around 700mb.

# **2) Transfer the file onto the system**

# Copy the file onto the target system by any means that works. This could be sftp, scp or even via a USB stick in case of a truly air-gapped system.

# **3) Load the image**

# Once the file is on the system you can load it like this:

#     gunzip openproject-11.tar.gz && docker load -i openproject-11.tar
    

# This extracts the archive and loads the contained image layers into docker. The .tar file can be deleted after this.

# **4) Proceed with the installation**

# After this both installation and later upgrades work just as usual. You only replaced `docker-compose pull` or the normal, implicit download of the image with the steps described here.

#!/bin/env bash

set -o errexit

SANITIZED_IMAGE_NAME=$(printf ${1} | ./_utils.sh sanitize_directory_name)
# docker pull "${1}" && 
docker save "${1}" | gzip > "${SANITIZED_IMAGE_NAME}.tar.gz"