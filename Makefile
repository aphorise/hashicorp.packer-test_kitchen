default: all
all: kitchen

vbox-nginx64.box: ubuntu16-nginx.json
	packer validate ubuntu16-nginx.json
	packer build -force -only=vbox-nginx64 ubuntu16-nginx.json

vmware-nginx64.box: ubuntu16-nginx.json
	packer validate ubuntu16-nginx.json
	packer build -force -only=vmware-nginx64 ubuntu16-nginx.json

kitchen-vbox: vbox-nginx64.box
	kitchen test vbox

kitchen-vmware: vmware-nginx64.box
	kitchen test vmware

kitchen: kitchen-vbox kitchen-vmware

.PHONY: clean
clean:
	-@vagrant box remove -f nginx64 --provider virtualbox 2>/dev/null || true
	-@vagrant box remove -f nginx64 --provider vmware_desktop 2>/dev/null || true
	-@kitchen destroy all 2>/dev/null || true
	-@rm -rf output-*/ *.box packer_cache rm -rf .kitchen