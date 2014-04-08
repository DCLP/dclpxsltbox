Sandbox for experimenting with DCLP/PN XSLT stuff

data/
=====

This is a hard copy (no linkage) of the prototype DCLP XML data files (https://github.com/papyri/idp.data/tree/dclp/DCLP), made on 3 April 2014.


xslt/
=====

XSLT files we want to play with, including:

quickview/
----------

Creates a single HTML tabular view of all the DCLP XML files you can point it to. 

At the command line (assuming you've installed Saxon-HE), you can run the trasform with something like:

    saxon -xsl:xslt/quickview/quickview.xsl -o:output/quickview.html -it:START datadir="$PWD/data"

In OxygenXML, you'll need to configure a "Transformation Scenario" in order to run the quickview transform through the bundled saxon. You must first create an Oxygen project file (.xpr). Then, use the following settings to set up the transformation scenario:

* Open quickview.xsl in OxygenXML and make sure it has the focus
* From the menu bar, select "Document" -> "Transformation" -> "Configure Transformation Scenario(s)..."
* In the "Configure Transformation Scenario(s)" dialog box:
    * make sure the "Association follows selection" check box is selected
    * select the "New" button and then choose "XSLT Transformation" from the contextual menu that appears
* In the "New Scenario" dialog box:
    * make sure the "Name" field contains "quickview" (without quotation marks)
    * for "Storage", select the "Project Options" radio button
    * on the "XSLT" tab:
        * leave the "XML URL" field empty
        * leave the intial value of "${currentFileURL}" in the "XSL URL" field
        * in the "Transformer" combo box, select "Saxon-HE 9.5.1.3" (vel sim)
        * select the small icon to the right of the "Transformer" combo box, which looks like a small cogwheel moving fast; this will display the Saxon HE configuration dialog (no title); under the heading "Initial mode and template", set the "Template ("-it")" field to "START" (without the quotation marks) and select the "OK" button
        * back on the "XSLT" tab of the "New Scenario" dialog box, below the "Transformer" combo box, select the "Parameters" button to display the "Configure Paramters" dialog; double-click on the "datadir" parameter and enter "../../data" (without the quotation marks) in the value field (this replaces the default path the xslt uses in looking for the input xml files; when running inside the Oxygen+saxon configuration bundle, it is relative to the xslt location); select the "OK" button
        * select the "OK" button on the "XSLT" tab
* Back on the "Configure Transformation Scenario(s)" dialog box, select the "Apply Associated" button to run the transform. 
* HTML output from the XSLT will appear in a new editor pane. If you want to have the output saved directly to file, edit the transformation scenario again and make changes on the "output" tab.

pn-xslt/
--------

The XSLT files used by the Papyrological Navigator to produce output in the production version of papyri.info. RDF2HTML.xsl has a title that is something of a misnomer (there are historical reasons for its name that we can overlook for now): it takes a papyrological data file (in TEI XML conforming to the EpiDoc standard) as input and produces HTML output. Like the quickview XSLT, we're using XSL version 2.0, so you have to use one of the recent Saxon family of processors. A value for the "collection" parameter must be passed in order to get the stylesheet to treat the data as belonging to the ddbdp, hgv, or apis collections.

At the command line (assuming you've installed Saxon-HE), you can run the transform with something like the following to get one of our DCLP example files treated as if it is an HGV file:

    saxon -xsl:xslt/pn-xslt/RDF2HTML.xsl -o:output/59122-hgv.html -s:data/60/59112.xml collection="hgv"

An APIS file:

    saxon -xsl:xslt/pn-xslt/RDF2HTML.xsl -o:output/59122-apis.html -s:data/60/59112.xml collection="apis"

A DDBDP file:

    saxon -xsl:xslt/pn-xslt/RDF2HTML.xsl -o:output/59122-ddbdp.html -s:data/60/59112.xml collection="ddbdp"

An OxygenXML transformation can also be configured for our XML files using the bundled copy of saxon-he and setting the "collection" parameter for the desired target.









  
