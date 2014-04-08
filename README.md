Sandbox for experimenting with DCLP/PN XSLT stuff

data/
=====

This is a hard copy (no linkage) of the prototype DCLP XML data files (https://github.com/papyri/idp.data/tree/dclp/DCLP), made on 3 April 2014.


xslt/
=====

XSLT files we want to play with, including:

quickview/
----------

Creates a single HTML tabular view of all the DCLP XML files you can point it to. Run like:

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

  
