all: swift-build swift-run

.PHONY: swift-build swift-run swift-run-nonflat

swift-build:
	docker build -t $@ -f Dockerfile .

swift-run-nonflat:
	docker build -t $@ -f Dockerfile.run .

swift-run: swift-run-nonflat
	docker run -d $< sleep 200
	docker export `docker ps -l -q` | docker import - $@
	
	
