Core tools for managing XSLT development for the Digital Corpus of Literary Papyrology (DCLP) project. 

## Setup

Several components are needed in order to set up a local working environment, including clones of 4 github git repositories. Before you start, you'll need github and sourceforge credentials, and you'll need to have been added to the developer teams for the [Github organization "DCLP"](https://github.com/DCLP/). You'll also need to set up ssh keys for working with [Github](https://help.github.com/articles/generating-ssh-keys). Once you've done those things, follow this checklist:

1. Create a working directory on your local machine wherever you like. You can name it whatever you want. We'll call it ```{your-working-dir}``` for the rest of this setup.
2. cd into ```{your-working-dir}```
3. Issue this command in ```{your-working-dir}```: 

    ```git clone git@github.com:DCLP/dclpxsltbox.git```

    This gets you a working copy of the dclpxsltbox repository, which contains transform tools and a place to put results for sharing back to github. The "master" branch, which is checked out by default by ```git clone``` represents the tested, deploy-to-production branch of the code in this repository.

4. Now issue this command in ```{your-working-dir}```:

    ```git clone git@github.com:DCLP/navigator.git```

    This gets you a working copy of the **"DCLP" fork** of the *Papyrological Navigator (PN)* code, which includes the PN-specific XSLT files that we are working on, i.e., navigator/pn-xslt). The "master" branch, which is checked out by default by ```git clone``` represents the tested, deploy-to-production branch of the DCLP version of the Papyrological Navigator.

5. Issue this command in ```{your-working-dir}```:

    ```git clone git@github.com:DCLP/epidoc-xslt.git```

    This gets you a working copy of the **"DCLP" fork** of the EpiDoc example stylesheets, which provide core style to the PN. The "master" branch, which is checked out by default by ```git clone``` represents the tested, deploy-to-production branch of the DCLP version of the Stylesheets. 

6. Now cd into the ```navigator``` directory that contains the clone you  created in step 4.

7. Issue this command in ```{your-working-dir}/navigator```:

    ```ln -s ../epidoc-xslt/example-p5-xslt/ ./epidoc-xslt```

    This step creates a symbolic link from ```{your-working-dir}/navigator/epidoc-xslt``` to the ```epidoc-xslt``` clone you created in step 5. This symbolic link permits the navigator xslt files to find the epidoc xslt files.

8. Now cd back to ```{your-working-dir}```.

9. Issue the following command:

    ```git clone git@github.com:DCLP/idp.data.git```

    This gets you a working copy of the big papyrological data repository; you may want to go get a cup of tea while this is cloning. The "master" branch, which is checked out by default by ```git clone``` represents the tested, deploy-to-production branch of the data in this repository.

You should end up with a directory structure that looks like this (irrelevant subdirectories have been omitted from the listing, replaced by ellipses):

<pre>{your-working-directory}/
    dclpxsltbox/
        bin/
        output/
            ...
        tests/
        xslt/
            quickview/
    epidoc-xslt/
        example-p5-xslt/
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

## Making changes

**"Master" means "production code". Never commit or merge changes to a "master" branch in any DCLP repository unless the code or data in question has been reviewed, tested, and deemed "ready to deploy."**

Changes to code or data must be governed by a ticket in [the DCLP Issue Tracker](https://github.com/DCLP/dclpxsltbox/issues) (we use one tracker for all DCLP repositories). Once a ticket has been created and assigned to you, follow these steps to work on it.

###Making changes to code in git repositories

1. In your local working copy/copies of the relevant repository/ies, verify that you have a clean checkout of the "master" branch (i.e., no pending changes locally), then make and check out a new branch for work on that issue. 

    Name the new branch like "issue\d+" where "\d+" is the number of the ticket in the Issue Tracker.

    Use a git command line like this: 

    ```git checkout -b issue123```

2. Immediately push the new branch to github with a git command like: 

    ```git push origin issue123```
 
3. Immediately add the "in work" label to the corresponding ticket in the issue tracker.

4. Work on changes locally as you will, committing changes early and often to your numbered "issue" branch. Frequently pushing those committed changes to the origin issue branch on github is also encouraged. If you need to make a temporary alternative branch, use a pattern like "issue123a".

5. When your code or data changes are ready for external test and review, [rebase](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) your numbered issue branch against "master" in the appropriate repository in order to replay your changes on top of the latest production code. Here's example code:

    ```
    git checkout issue123
    git rebase master
    git push origin issue123
    ```

6. On the ticket in the issue tracker, remove the "in work" label and add the "review" label. Reassign the ticket to a lead developer or the person who requested the feature or bug fix. Add a comment, including an "[@mention](https://github.com/blog/821-mention-somebody-they-re-notified)" for the assignees, indicating what has been changed. This comment, ideally, should mention the numbered test branch by name and also point via github URL to the most recent commit in that branch. 

###Making changes to code in svn repositories (i.e., the EpiDoc Stylesheets)

Right now, we just commit locally tested changes to the "dclp" branch; however, this is bad practice. We need urgently to develop an issue-level branch process for this as well.

##How to run XSL transforms

At the command line (assuming you've installed Saxon-HE) and you're sitting in the top level "your-working-directory" (i.e. the parent directory of dclpxsltbox; see above), you can run the transform with something like the following to get one of our DCLP example files transformed with whatever combination of XSLT files from the PN and EpiDoc repositories you have sitting in your local sandboxes:

    saxon -xsl:navigator/pn-xslt/MakeHTML.xsl -o:dclpxsltbox/output/DCLP/81/80756.html -s:idp.data/DCLP/81/80756.xml collection="dclp" analytics="no" cssbase="../../css" jsbase="../../js" path="$PWD/idp.data"

If you want to make sure you haven't messed up the stylesheets for one of the existing collections, try something like:

    saxon -xsl:navigator/pn-xslt/MakeHTML.xsl -o:dclpxsltbox/output/HGV/HGV62/61399.html -s:idp.data/HGV_meta_EpiDoc/HGV62/61399.xml collection="hgv" analytics="no" cssbase="../../css" jsbase="../../js" path="$PWD/idp.data"

If you want to transform all of the DCLP files you have locally, there's a script that uses Hugh Cayless's claxon wrapper for saxon to rip through them all. It's much much faster than issuing a separate saxon call for each transform. It's called ```2html.sh``` and you'll find it in ```dclpxsltbox/bin/```. It expects a single command-line parameter, a path (absolute or relative) to the "your-working-directory" (i.e. the parent directory of dclpxsltbox). So, if you're currently occupying said directory, you'd use a command line like:

    dclpxsltbox/bin/2html.sh .

If you're on Windows, there's a similar batch file called ```2html_window.bat```.

An OxygenXML transformation can also be configured for our XML files using the bundled copy of saxon-he and setting the "collection" parameter for the desired target.

## How to do Regression Testing

There is now a script for making sure that changes for dclp don't mess up the other collections. Find it in tests/test_regression.py. It uses checksums to see if some files from other collections that shouldn't be changed by our transforms have been. Running it won't mess with any content in the top-level output directory; everything is confined to the tests subdirectory and its descendants. At the moment, Windows is not fully supported, but Mac/Linux is. Run like: ```python test_regression.py -v```. Using ```-vv``` will give you full debug output, which may be helpful if files aren't being found in the right place. If any problems are found, you'll see a critical logging error with details about the test file that exhibits unexpected changes.








  
