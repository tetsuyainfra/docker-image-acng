

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
$(ACNG_BUILD_FILE): acng/Dockerfile acng/entrypoint.sh
	docker build -t acng:latest -f acng/Dockerfile ./acng
	touch $@

run_acng: $(ACNG_BUILD_FILE)
	docker run --rm --name acng -p 3142:3142 acng:latest

#
# Squid
#