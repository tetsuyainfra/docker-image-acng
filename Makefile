
TOP_MIRROR_DEBIAN:=http://ftp.riken.jp/Linux/debiani/debian/
TOP_MIRROR_UBUNTU:=http://ftp.riken.jp/Linux/ubuntu/
# TOP_MIRROR_DEBIAN:=http://mirror.xtom.jp/debian/
# TOP_MIRROR_UBUNTU:=http://mirror.xtom.jp/ubuntu/

ACNG_BUILD_FILE := tmp/.build-acng

.PHONY: build
ALL: build

clean:
	docker rmi acng:latest || true
	rm -f $(ACNG_BUILD_FILE)

clean_cache: clean
	docker builder prune -f

build: $(ACNG_BUILD_FILE)

#
# Apt-Cacher-NG
#
$(ACNG_BUILD_FILE): acng/Dockerfile acng/entrypoint.sh $(wildcard acng/conf/*)
	docker build -t acng:latest -f acng/Dockerfile ./acng
	touch $@

run_acng: $(ACNG_BUILD_FILE)
	docker run --rm --name acng -p 3142:3142 \
		-e TOP_MIRROR_DEBIAN='$(TOP_MIRROR_DEBIAN)' \
		-e TOP_MIRROR_UBUNTU='$(TOP_MIRROR_UBUNTU)' \
		acng:latest

conf_acng: $(ACNG_BUILD_FILE)
# Copy default config files from the image to local directory ./tmp
# but /etc/apt-cacher-ng include link files
	CONTAINER_ID=$$(docker create acng:latest) ; \
	docker container cp $$CONTAINER_ID:/etc/apt-cacher-ng ./tmp ; \
	docker container rm $$CONTAINER_ID

rocks_acng: $(ACNG_BUILD_FILE)
	CONTAINER_ID=$$(docker create acng:latest) ; \
	docker container cp $$CONTAINER_ID:/usr/share/rocks/packages.list ./tmp ; \
	docker container rm $$CONTAINER_ID

#
# Squid
#