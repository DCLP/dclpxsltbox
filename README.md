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

At the command line (assuming you've installed Saxon-HE) and you're sitting in the top level "your-directory-name" (see above), you can run the transform with something like the following to get one of our DCLP example files transformed with whatever combination of XSLT files from the PN and EpiDoc repositories you have sitting in your local sandboxes:

    saxon -xsl:navigator/pn-xslt/MakeHTML.xsl -o:/dclpxsltbox/output/DCLP/81/80756.html -s:idp.data/DCLP/81/80756.xml collection="dclp" analytics="no" cssbase="../../css" jsbase="../../js"

If you want to make sure you haven't messed up the stylesheets for one of the existing collections, try something like:

    saxon -xsl:navigator/pn-xslt/MakeHTML.xsl -o:/dclpxsltbox/output/HGV/HGV62/61399.html -s:idp.data/HGV_meta_EpiDoc/HGV62/61399.xml collection="hgv" analytics="no" cssbase="../../css" jsbase="../../js"

If you want to transform all of the DCLP files you have locally, there's a script that uses Hugh Cayless's claxon wrapper for saxon to rip through them all. It's much much faster than issuing a separate saxon call for each transform:

    dclpxsltbox/bin/2html.sh

Or if you're on Windows, a batch file:

    dclpxsltbox\bin\2html_window.bat

An OxygenXML transformation can also be configured for our XML files using the bundled copy of saxon-he and setting the "collection" parameter for the desired target.









  
