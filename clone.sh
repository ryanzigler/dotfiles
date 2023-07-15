#!/bin/sh

echo "Cloning repositories..."

CODE=$HOME/Code
CRO=$CODE/crometrics

# Personal

# Cro Metrics
git@github.com:CROmetrics/crometrics-experiments.git $CRO/crometrics-experiments
git@github.com:CROmetrics/oli-chrome.git $CRO/oli-chrome
