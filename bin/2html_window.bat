IF [%1]==[] ( echo ayuu nai
) ELSE (java -jar %1\bin\claxon-1.0.0-SNAPSHOT-standalone.jar --xsl %1\xslt\pn-xslt\RDF2HTML.xsl --dir %1\data\ --out %1\output\dclp\ --ext .html collection dclp analytics no cssbase '..\..\css' jsbase '..\..\js')
