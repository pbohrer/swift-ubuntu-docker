#
#	Even though these are set in the Dockerfile, we will
#	pass them in to make sure we are consistent
#
SWIFT_SNAPSHOT=swift-3.0.2-RELEASE
UBUNTU_VERSION=ubuntu14.04

SWIFT_SNAPSHOT_LOWERCASE=`echo $(SWIFT_SNAPSHOT) | tr A-Z a-z`
UBUNTU_VERSION_NO_DOTS=$(subst .,,$(UBUNTU_VERSION))

all: swift-build swift-run

.PHONY: swift-build swift-run swift-run-nonflat

swift-build:
	docker build --build-arg SWIFT_SNAPSHOT=$(SWIFT_SNAPSHOT) --build-arg SWIFT_SNAPSHOT_LOWERCASE=$(SWIFT_SNAPSHOT_LOWERCASE) --build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) --build-arg UBUNTU_VERSION_NO_DOTS=$(UBUNTU_VERSION_NO_DOTS) -t $@ -f Dockerfile .

swift-run-nonflat:
	docker build --build-arg SWIFT_SNAPSHOT=$(SWIFT_SNAPSHOT) --build-arg SWIFT_SNAPSHOT_LOWERCASE=$(SWIFT_SNAPSHOT_LOWERCASE) --build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) --build-arg UBUNTU_VERSION_NO_DOTS=$(UBUNTU_VERSION_NO_DOTS) -t $@ -f Dockerfile.run .

swift-run: swift-run-nonflat
	docker run -d $< sleep 90
	docker export `docker ps -l -q` | docker import - $@ --change "WORKDIR /root/app"
	
	
