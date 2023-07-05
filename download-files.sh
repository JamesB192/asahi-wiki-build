#!/usr/bin/env bash

set -e

if ! [[ -e content ]]; then
	echo "Downloading wiki content..."
	git clone --depth 1 https://github.com/AsahiLinux/docs.wiki.git content

	echo "Preparing wiki content..."

	# - Convert MediaWiki-style links in the content files to Markdown links
	# - Convert GitHub repository blob URLs to raw URLs
	sed -i \
		-e 's/\[\[\(.*\)|alt=\(.*\)\]\]/!\[\2\](\1)/g' \
		-e 's/\[\[\(.*\)\]\](\(.*\))/\[\1\](\2)/g' \
		-e 's/\[\[\(.*\)\]\]/\[\1\]({{<internal-link `\1`>}})/g' \
		-e 's/\(!\[.*\](\https:\/\/github\.com\/.*\/\)blob\(\/.*)\)/\1raw\2/g' \
		content/*.md

	# Make page titles more human-readable
	for file in content/*.md; do
		[[ ${file} == content/_*.md ]] && continue
		basename=$(basename -s '.md' "${file}")
		title=${basename//-/ }
		sed -i -e "1s/^/---\ntitle: '${title}'\n---\n/" "${file}"
	done

	mv content/{Home,_index}.md
fi

if ! [[ -e themes/hugo-geekdoc ]]; then
	echo "Downloading theme..."
	mkdir -p themes/hugo-geekdoc
	curl -L https://github.com/thegeeklab/hugo-geekdoc/releases/latest/download/hugo-geekdoc.tar.gz | tar -xz -C themes/hugo-geekdoc --strip-components=1
fi
