#!/bin/bash


 
## "echo $?" # 1 = fail 0 = public key fits sign
## public keys taken from site.conf

echo ""
echo "fffl testscript for manifest signs"
echo ""
 
echo "stable horst:"
sh ./gluon/contrib/sigtest.sh 450f99d2be2e919a8c80c8aa0a1d6c1db0c625ff55da107c34b5b190507590cc  ./gluon/output/images/sysupgrade/stable.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "stable sven:"
sh ./gluon/contrib/sigtest.sh 359ec3619184f1bdfe26515cf5ba2b016ba23489db2a371cbf5c3cee9d061110  ./gluon//output/images/sysupgrade/stable.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "stable fabian:"
sh ./gluon/contrib/sigtest.sh f860ea1d4fb7e926e5fa45f6c7b1bbc8c3870f1e09de6a00b273999e1644ccdd  ./gluon//output/images/sysupgrade/stable.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "stable bigfoot:"
sh ./gluon/contrib/sigtest.sh c83161964de2763ab2fc5730dcc0f8766212f130e6b48b3b42d7f1055c05a2be  ./gluon/output/images/sysupgrade/stable.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "stable yellni:"
sh ./gluon/contrib/sigtest.sh 0ed2430b8f508b6cfddbe30c6839fc76b294e106da7eda8af179f88bc16e1b3f  ./gluon/output/images/sysupgrade/stable.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "stable mlt:"
sh ./gluon/contrib/sigtest.sh 15f49b739925c0e14d1c547818c57664158e509d26e94314dd9d6a23ed797ff3  ./gluon/output/images/sysupgrade/stable.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "#################"
echo ""

echo "experimental horst:"
sh ./gluon/contrib/sigtest.sh 450f99d2be2e919a8c80c8aa0a1d6c1db0c625ff55da107c34b5b190507590cc  ./gluon/output/images/sysupgrade/experimental.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "experimental sven:"
sh ./gluon/contrib/sigtest.sh 359ec3619184f1bdfe26515cf5ba2b016ba23489db2a371cbf5c3cee9d061110  ./gluon/output/images/sysupgrade/experimental.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "experimental fabian:"
sh ./gluon/contrib/sigtest.sh f860ea1d4fb7e926e5fa45f6c7b1bbc8c3870f1e09de6a00b273999e1644ccdd  ./gluon/output/images/sysupgrade/experimental.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "experimental bigfoot:"
sh ./gluon/contrib/sigtest.sh c83161964de2763ab2fc5730dcc0f8766212f130e6b48b3b42d7f1055c05a2be  ./gluon/output/images/sysupgrade/experimental.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "experimental yellni:"
sh ./gluon/contrib/sigtest.sh 0ed2430b8f508b6cfddbe30c6839fc76b294e106da7eda8af179f88bc16e1b3f  ./gluon/output/images/sysupgrade/experimental.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""

echo "experimental mlt:"
sh ./gluon/contrib/sigtest.sh 15f49b739925c0e14d1c547818c57664158e509d26e94314dd9d6a23ed797ff3  ./gluon/output/images/sysupgrade/experimental.manifest
val="$?"; if [ $val = 0 ]; then echo "ok! public key fits sign"; else echo "fail"; fi
echo ""


