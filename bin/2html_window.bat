IF [%1]==[] ( echo ayuu nai
) ELSE (java -jar %1\dclpxsltbox\bin\claxon-1.0.0-SNAPSHOT-standalone.jar --xsl %1\navigator\pn-xslt\MakeHTML.xsl --dir %1\idp.data\DCLP\ --out %1\dclpxsltbox\output\dclp\ --ext .html collection dclp analytics no cssbase '..\..\css' jsbase '..\..\js')
