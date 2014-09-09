Core tools for managing XSLT development for the Digital Corpus of Literary Papyrology (DCLP) project. 

Setup
=====

Several components are needed in order to set up a local working environment, including clones of 3 github git repositories and a checkout of a sourceforge svn repository. Before you start, you'll need github and sourceforge credentials, and you'll need to have been added to the developer teams for the [Github organization "DCLP"](https://github.com/DCLP/) and for the [Sourceforge Project "EpiDoc"](http://epidoc.sf.net). You'll also need to set up ssh keys for working with both [Github](https://help.github.com/articles/generating-ssh-keys) and [SourceForge](http://sourceforge.net/apps/trac/sourceforge/wiki/SSH%20keys). Once you've done those things, follow this checklist:

1. Create a working directory on your local machine wherever you like. You can name it whatever you want. We'll call it ```{your-working-dir}``` for the rest of this setup.
2. cd into ```{your-working-dir}```
3. Issue this command in ```{your-working-dir}```: 

    ```git clone git@github.com:DCLP/dclpxsltbox.git```

    This gets you a local copy of this dclpxsltbox repository, which contains transform tools and a place to put results for sharing back to github.

4. Now issue this command in ```{your-working-dir}```:

    ```git clone git@github.com:DCLP/navigator.git -b xslt-master```

    This gets you the **"xslt-master" branch** of the **"DCLP" fork** of the *Papyrological Navigator (PN)* code, which includes the PN-specific XSLT files that we are working on, i.e., navigator/pn-xslt)

5. Now cd into the ```navigator``` directory that contains the clone you just created in step 4.

6. Issue this command in ```{your-working-dir}/navigator```:

    ```svn checkout svn+ssh://{USERNAME}@svn.code.sf.net/p/epidoc/code/branches/dclp/example-p5-xslt epidoc-xslt```

    **Change {USERNAME} to your sourceforge username.**

    This gets you a R/W checkout of the DCLP branch of the EpiDoc example stylesheets, which provide core style to the PN; make sure you check out the **"dclp" branch** and that you name it as indicated! If you follow the code snippet above exactly, that should happen automatically.

7. cd back to ```{your-working-directory}```

8. Issue the following command:

    ```git clone git@github.com:DCLP/idp.data.git -b dclp```

    This gets you the **"dclp" branch** of the big papyrological data repository; you may want to go get a cup of tea while this is cloning.

You should end up with a directory structure that looks like this (irrelevant subdirectories have been ommitted from the listing, replaced by ellipses):

<pre>{your-working-directory}/
    dclpxsltbox/
        bin/
        output/
            ...
        tests/
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

Regression Testing
==================

There is now a script for making sure that changes for dclp don't mess up the other collections. Find it in tests/test_regression.py. It uses checksums to see if some files from other collections that shouldn't be changed by our transforms have been. Running it won't mess with any content in the top-level output directory; everything is confined to the tests subdirectory and its descendants. At the moment, Windows is not fully supported, but Mac/Linux is. Run like: ```python test_regression.py -v```. Using ```-vv``` will give you full debug output, which may be helpful if files aren't being found in the right place. If any problems are found, you'll see a critical logging error with details about the test file that exhibits unexpected changes.








  
