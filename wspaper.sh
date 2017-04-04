#!/bin/sh
rm -rf META-INF Resources Stories MasterSpreads mimetype Spreads XML designmap.xml; 
echo '<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8">' > "result.html";
echo '<title></title>' >> "result.html";
echo '</head><body>' >> "result.html";
for f in *.idml ; 
do idml2html "$f" "result.html"; 
rm -rf META-INF Resources Stories MasterSpreads mimetype Spreads XML designmap.xml ; 
done
echo '</body></html>' >> "result.html";
sed -i 's|<strong>누구의 말일까요?|누구의 말일까요?|g' result.html;