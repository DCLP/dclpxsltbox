Core tools for managing XSLT development for the Digital Corpus of Literary Papyrology (DCLP) project. 

## Setup

Several components are needed in order to set up a local working environment, including clones of 4 GitHub git repositories. Before you start, you'll need GitHub credentials, and you'll need to have been added to the developer teams for the [Github organization "DCLP"](https://github.com/DCLP/). You'll also need to set up ssh keys for working with [Github](https://help.github.com/articles/generating-ssh-keys). Once you've done those things, follow the checklists below.

### Directory structure and repository clones

1. Create a working directory on your local machine wherever you like. You can name it whatever you want. We'll call it ```{your-working-dir}``` for the rest of this setup.

2. cd into ```{your-working-dir}```

3. Issue the following commands in ```{your-working-dir}``` in order to create clones of needed repositories from GitHub. Note that final clone (idp.data) is likely to take a long time to complete because the repository in question is big.

   * ```git clone git@github.com:DCLP/dclpxsltbox.git```
   * ```git clone git@github.com:DCLP/epidoc-xslt.git```
   * ```git clone git@github.com:DCLP/navigator.git```
   * ```git clone git@github.com:DCLP/xsugar.git```
   * ```git clone git@github.com:DCLP/idp.data.git```

4. Now cd into the ```navigator``` clone directory and issue this command:

   * ```ln -s ../epidoc-xslt/example-p5-xslt/ ./epidoc-xslt```

      This step creates a symbolic link from ```{your-working-dir}/navigator/epidoc-xslt``` to the ```epidoc-xslt``` clone. This symbolic link permits the navigator xslt files to find the epidoc xslt files.

You should end up with a directory structure that looks like this (irrelevant subdirectories have been omitted from the listing, replaced by ellipses):

```
{your-working-directory}/
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
    xsugar/
        ...
```

### Third-party software installation

Software necessary to run the full XSL transformation (```dclpxsltbox/bin/2html.sh```) is included in the ```dclpxsltbox``` clone, so no additional installation is required. Installation of the OxygenXML editor or of a Saxon distribution may be of value to developers for doing one-off tests.

Software installation is necessary to run the XSugar transformation tool for Leiden+ development and testing. Here is a checklist:

1. Install Apache Maven:
 
   on OSX: 

   * ```brew install maven```
 
   on Windows:

   * Follow steps mentioned on website : http://maven.apache.org/download.cgi

2. Install Ruby 1.7.26 (this unsupported, down version **is required**) using rbenv:

   on OSX:

   * ```brew install rbenv```
   * Add the rbenv shim code to your shell startup and resource it. The line to add to your ~/.bash_profile is:
      * ```eval "$(rbenv init -)"```
   * ```brew install ruby-build```
   * ```rbenv install jruby-1.7.26```

   on Windows:

   * Download jruby from [here](http://jruby.org/files/downloads/index.html)
   * Add environment variable “path” and insert value of “path” as location of jruby/bin folder

3. Cd into ```{your-working-directory}/xsugar``` and install the "bundler" Ruby gem: ```gem install bundler```. You may be prompted to install dependencies.

4. Run coverage tests to verify installation and configuration. 

   Use the “bundler” Ruby gem to execute the coverage tests on a small part of the Duke Databank data (to make sure everything is installed and working): 

```
jruby -Xcompat.version=1.8 -S bundle exec rake coverage:ddb \
DDB_DATA_PATH=../idp.data/DDB_EpiDoc_XML/c.etiq.mom \
SAMPLE_FRAGMENTS=-1 HTML_OUTPUT=../coverage.html
```

## Making changes

**"Master" means "production code". Never commit or merge changes to a "master" branch in any DCLP repository unless the code or data in question has been reviewed, tested, and deemed "ready to deploy."**

Changes to code or data must be governed by a ticket in [the DCLP Issue Tracker](https://github.com/DCLP/dclpxsltbox/issues) (we use one tracker for all DCLP repositories). Once a ticket has been created and assigned to you, follow these steps to work on it.

### Making changes to code in git repositories

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

##How to run XSL transforms

At the command line (assuming you've installed Saxon-HE) and you're sitting in the top level "your-working-directory" (i.e. the parent directory of dclpxsltbox; see above), you can run the transform with something like the following to get one of our DCLP example files transformed with whatever combination of XSLT files from the PN and EpiDoc repositories you have sitting in your local sandboxes:

    saxon -xsl:navigator/pn-xslt/MakeHTML.xsl -o:dclpxsltbox/output/DCLP/81/80756.html -s:idp.data/DCLP/81/80756.xml collection="dclp" analytics="no" cssbase="../../css" jsbase="../../js" path="$PWD/idp.data"

If you want to make sure you haven't messed up the stylesheets for one of the existing collections, try something like:

    saxon -xsl:navigator/pn-xslt/MakeHTML.xsl -o:dclpxsltbox/output/HGV/HGV62/61399.html -s:idp.data/HGV_meta_EpiDoc/HGV62/61399.xml collection="hgv" analytics="no" cssbase="../../css" jsbase="../../js" path="$PWD/idp.data"

If you want to transform all of the DCLP files you have locally, there's a script that uses Hugh Cayless's claxon wrapper for saxon to rip through them all. It's much much faster than issuing a separate saxon call for each transform. It's called ```2html.sh``` and you'll find it in ```dclpxsltbox/bin/```. It expects a single command-line parameter, a path (absolute or relative) to the "your-working-directory" (i.e. the parent directory of dclpxsltbox). So, if you're currently occupying said directory, you'd use a command line like: ```dclpxsltbox/bin/2html.sh .```

If you're on Windows, there's a similar batch file called ```2html_window.bat```.

An OxygenXML transformation can also be configured for our XML files using the bundled copy of saxon-he and setting the "collection" parameter for the desired target.

## How to do Regression Testing

**needs update**

There is now a script for making sure that changes for dclp don't mess up the other collections. Find it in tests/test_regression.py. It uses checksums to see if some files from other collections that shouldn't be changed by our transforms have been. Running it won't mess with any content in the top-level output directory; everything is confined to the tests subdirectory and its descendants. At the moment, Windows is not fully supported, but Mac/Linux is. Run like: ```python test_regression.py -v```. Using ```-vv``` will give you full debug output, which may be helpful if files aren't being found in the right place. If any problems are found, you'll see a critical logging error with details about the test file that exhibits unexpected changes.








  
