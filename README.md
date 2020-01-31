# HashiCrop `packer` Templates with **test `kitchen`**
This repo contains a `packer` template for building two Vagrant Base Box's for **Virtualbox** & **VMWare** - that are then tested using the **Test Kitchen** tool.


### Prerequisites
Ensure that you already have the following applications installed & working:
 - [**Virtualbox**](https://www.virtualbox.org/)
 - [**Virtualbox Guest Additions (VBox GA)**](https://download.virtualbox.org/virtualbox/)
 - > **MacOS** (aka OSX) - VirtualBox 6.x+ is expected to be shipped with the related .iso present under (eg):
 `/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso`
You may however need to download the .iso specific to your version (mount it) and execute the VBoxDarwinAdditions.pkg
 - [**Vagrant**](https://www.vagrantup.com/)
 - [**Packer**](https://www.packer.io/)
 - [**ChefDK**](https://downloads.chef.io/chefdk/4.7.73)
 - [**Test Kitchen**](https://github.com/test-kitchen/test-kitchen) 
 - **VMWare specific** - **skip** if not needed / see below notes.
 - - :key: Linux / Windows: [**VMware Workstation Player**](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html) OR MacOS: [**VMware Fusion**](https://www.vmware.com/products/fusion/fusion-evaluation.html)
 - - :key: [**Vagrant VMware License**](https://www.vagrantup.com/vmware/)
 - - [**Vagrant VMware Utility**](https://www.vagrantup.com/vmware/downloads.html) specific to your OS.


## Installations & Setup
Having completed the installation of the aforementioned prerequisites **ChefDK** & **Test Kitchen** are the first items to verify. Begin by ensuring that your shell profile (`.bash_profile` or `.bashrc`) is pointing to the correct version of `ruby` that's shipped with ChefDK (OPTION-1); **alternatively** you can opt for **`rbenv`** detailed further on (OPTION-2) - the key with either approach is to ensure you have a working error-free CLI execution of `chef` & `kitchen`.

**OPTION-1**:
```bash
# // ruby paths from chefdk to be added to .bash_profile
export PATH="/opt/chefdk/embedded/bin:$PATH" ;
export PATH="/opt/chefdk/bin:$PATH" ;
export PATH="$HOME/.chefdk/gem/ruby/2.6.0/bin:$PATH" ;
# // be sure to 'source ~/.bash_profile' after adding them or start a new terminal.
gem install bundler ;
```

**OPTION-2**:
On macOS (aka OSX) you may face some issues with the installation of specific versions via `rbenv` (eg: [1](https://stackoverflow.com/a/59977338/4887288), [2](https://stackoverflow.com/a/59987407/4887288)) that can conflict with existing installs such as: binutils, llvm or other gnu applications - these should be uninstalled and `rbenv` re-attempted; you can opt for OPTION-1 if you're still facing issues. 
```bash
#brew uninstall binutils ; # temporarily remove if applicable.
brew install rbenv coreutils; # see: https://github.com/rbenv/rbenv - if needing to build 
# // IF rbenv is not already in paths then add:
#printf '\n#rbenv paths\nexport PATH="/usr/local/bin/rbenv:$PATH"\n\n' >> ~/.bash_profile ;
printf '\n#rbenv load automatically\neval "$(rbenv init -)"\n\n' >> ~/.bash_profile ;
source ~/.bash_profile ;
rbenv install 2.6.0 && rbenv local 2.6.0 ;
gem install bundler ;
#brew install binutils ; # re-install if needed.
#rbenv global 2.6.0 ; # ADVISED for future runs (not to forget)
```

**VERIFY**
```bash
chef --version ; # should output without complaint
ChefDK version: 4.7.73
# ...

kitchen version ; # check kitchen is also without complaint.
Test Kitchen version 2.3.4
```

## Usage
Subject to the setup you may need to `bundle kitchen ...` on CLI instead of `kitchen ...`.

### Manual Usage
To perform all steps manually - follow the step outlined below from the root of this repository:
```bash
bundle install ; # should be run from root of this repo.

packer build -force ubuntu16-nginx.json ;
# ^^ generate all vagrant vbox images at the same time in parallel.

kitchen test ; # tests everything
# ^^ also performs kitchen converge & verify - for image specific tests:
#kitchen test vbox ;
#kitchen test vmware ;
# on 1st run you'll get prompted: Do you accept the 2 product licenses (yes/no)?

# when finished clean-up
vagrant box remove -f nginx64 --provider virtualbox
vagrant box remove -f nginx64 --provider vmware_desktop
kitchen destroy all
rm -rf output-*/ *.box packer_cache rm -rf .kitchen
```

### Make Usage
```bash
bundle install ; # should be run from root of this repo.
make ; # uses steps in Makefile
# images are sequentially created and tested 
make clean ; # deletes all that was generated.
```


## VMWare Specifics
If you do not want to `packer build` or `kitchen ...` VMware aspects of this code - then adjust / remove related portions from the packer template `ubuntu16-nginx.json`, `kitchen.yml` and `Make` files accordingly.
**IMPORTANT**: A fully **licensed** (non-trial) version of VMware must be installed and **Vagrant VMware Utility** with a valid **Vagrant VMware License** as noted earlier.
```bash
vagrant plugin install vagrant-vmware-desktop ;
vagrant plugin license vagrant-vmware-desktop ~/license.lic ; # Your license.
vagrant plugin list ;
```
:warning: **ISSUES** :warning: In VMware Fusion I've observed that during the `kitchen test vmware` phase it can hang (occasionally) with an output similar to that noted below. In such cases - the only recommendation is to remove all temporary files / folders that were generated and to re-attempt the process again anew. A reboot of your system may also help.
```
       Finished destroying <default-vmware-nginx64> (0m0.00s).
-----> Testing <default-vmware-nginx64>
-----> Creating <default-vmware-nginx64>...
       Bringing machine 'default' up with 'vmware_desktop' provider...
       ==> default: Verifying vmnet devices are healthy...
       ==> default: Preparing network adapters...
       ==> default: Starting the VMware VM...
       ==> default: Waiting for the VM to receive an address...

# ^^^ can indefinitely wait here ^^^
```


## Tests
Only 2 tests are performed - 1) to ensure nginx package is installed & 2) that the box is listening on loopback / 127.0.0.1 port 80. To extend or add additional checks refer to the [**inspec**](https://www.inspec.io/docs/reference/resources/) documentation which provides for much more.


## Notes
This is intended as a mere practise / training exercise - make proper adjustments & reviews where intending to extend toward full pledged usage.


## Reference
Reference of material extended / reused:
 * [kikitux/packer_xenial64/](https://github.com/kikitux/packer_xenial64/)
 * [How To Test Your Ansible Deployment with InSpec and Kitchen](https://www.digitalocean.com/community/tutorials/how-to-test-your-ansible-deployment-with-inspec-and-kitchen)
------
