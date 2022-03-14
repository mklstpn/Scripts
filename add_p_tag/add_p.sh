#!/bin/bash

sed -e 's/$/<\/p>/' -i text.txt
sed -e 's/^/<p>/' -i text.txt