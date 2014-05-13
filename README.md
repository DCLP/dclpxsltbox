Core tools for managing XSLT development for the Digital Corpus of Literary Papyrology (DCLP) project. 

Setup
=====

Several components are needed in order to set up a local working environment, including clones of 3 github git repositories and a checkout of a sourceforge svn repository. Here's how:

1. Create a working directory on your local machine.
2. cd into that working directory
3. git clone git@github.com:DCLP/dclpxsltbox.git (this gets you this repos: transform tools and a place to put results for sharing)
4. git clone git@github.com:DCLP/navigator.git -b xslt-development (this gets you the xslt-development branch of the DCLP fork of the Papyrological Navigator code, which includes the PN-specific XSLT files that we are working on, i.e., navigator/pn-xslt)
5. cd navigator
6. svn checkout svn+ssh://USERNAME@svn.code.sf.net/p/epidoc/code/branches/dclp/example-p5-xslt epidoc-xslt (change USERNAME to your sourceforge username; supposing you already have ssh keys set up on sourceforge and commit privileges with EpiDoc, this gets you a R/W checkout of the DCLP branch of the EpiDoc example stylesheets, which provide core style to the PN; make sure you check out the branch and that you name it as indicated!)
7. cd ..
8. git clone git@github.com:DCLP/idp.data.git -b dclp (this gets you the dclp branch of the big data repository; you may want to go get a cup of tea while this is cloning)
9. pat yourself on the back

You should end up with a directory structure that looks like this (irrelevant subdirectories have been ommitted from the listing, replaced by ellipses):

<pre>your-directory-name/
    dclpxsltbox/
        bin/
        output/
            ...
        xslt/
            quickview/
    idp.data/
        ...
        DCLP/
        ...
    navigator/
        ...
        epidoc-xslt/
        ...
        pn-xslt/
</pre>

What's here
============

There have been a number of changes to this setup since the original version. Most notably, the testbox versions of the data and pn-xslt and epidoc xslts have been ripped out and are managed via their own repos now (as indicated above). The quickview xslt is still packaged here, as are the transformation tools in the dclpxsltbox/bin/ subdirectory.


How to
======

What follows needs revising. Badly.

At the command line (assuming you've installed Saxon-HE), you can run the transform with something like the following to get one of our DCLP example files treated as if it is an HGV file:

    saxon -xsl:xslt/pn-xslt/RDF2HTML.xsl -o:output/59122-hgv.html -s:data/60/59112.xml collection="hgv"

An APIS file:

    saxon -xsl:xslt/pn-xslt/RDF2HTML.xsl -o:output/59122-apis.html -s:data/60/59112.xml collection="apis"

A DDBDP file:

    saxon -xsl:xslt/pn-xslt/RDF2HTML.xsl -o:output/59122-ddbdp.html -s:data/60/59112.xml collection="ddbdp"

An OxygenXML transformation can also be configured for our XML files using the bundled copy of saxon-he and setting the "collection" parameter for the desired target.









  
