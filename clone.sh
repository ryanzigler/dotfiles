#!/bin/sh

echo "Cloning repositories..."

CODE_DIR=$HOME/Code/work/crometrics

# Cro Metrics
git@github.com:CROmetrics/crometrics-experiments.git $CODE_DIR/crometrics-experiments
git@github.com:CROmetrics/oli-chrome.git $CODE_DIR/oli-chrome
git@github.com:CROmetrics/libraries.git $CODE_DIR/libraries
git@github.com:CROmetrics/astro-design-system.git $CODE_DIR/astro-design-system
