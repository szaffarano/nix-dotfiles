#!/usr/bin/env bash

lscpu | grep Architecture | cut -d ":" -f2 | tr -d " "
