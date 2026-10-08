#!/bin/zsh

echo "Cloning repositories..."

CODE_DIR=$HOME/Developer/work/crometrics

# Cro Metrics
git clone git@github.com:CROmetrics/oli-chrome.git $CODE_DIR/oli-chrome
git clone git@github.com:CROmetrics/crometrics-experiments.git $CODE_DIR/crometrics-experiments
git clone git@github.com:CROmetrics/libraries.git $CODE_DIR/libraries
git clone git@github.com:CROmetrics/astro-design-system.git $CODE_DIR/astro-design-system
