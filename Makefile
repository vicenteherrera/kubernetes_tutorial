.PHONY: prerequisites serve-watch build install test

all: prerequisites serve-watch

prerequisites:
	gem install bundler
	bundle install

serve-watch:
	bundle exec jekyll serve --watch

test:
	exit 0

update:
	bundle update