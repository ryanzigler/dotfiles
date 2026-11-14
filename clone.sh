#!/bin/zsh

echo "Cloning repositories..."

CODE_DIR=$HOME/Developer/work/crometrics

# Cro Metrics
for repo in oli-chrome crometrics-experiments libraries astro-design-system; do
	if [[ -e $CODE_DIR/$repo ]]; then
		echo "Skipping $repo: $CODE_DIR/$repo already exists"
		continue
	fi

	git clone git@github.com:CROmetrics/$repo.git $CODE_DIR/$repo
done
