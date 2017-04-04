#!/bin/sh
rm -rf META-INF Resources Stories MasterSpreads mimetype Spreads XML designmap.xml; for f in *.idml ; do idml2html "$f" "result.html"; rm -rf META-INF Resources Stories MasterSpreads mimetype Spreads XML designmap.xml ; done
