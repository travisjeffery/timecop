IMAGE_NAME=timecop
VOLUMES=-v $(PWD):/tmp/src

image:
	docker build -t $(IMAGE_NAME) .

clean:
	rm Gemfile.lock

test: image
	docker run $(IMAGE_NAME) rake

console: image
	docker run -it --rm -w /tmp/src $(VOLUMES) $(IMAGE_NAME)

shell: image
	docker run -it --rm -w /tmp/src $(VOLUMES) $(IMAGE_NAME) bash
