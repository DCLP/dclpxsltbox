<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:papy="Papyrillio"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fm="http://www.filemaker.com/fmpxmlresult"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns="http://www.tei-c.org/ns/1.0">

    <!--
        java -Xms512m -Xmx1536m net.sf.saxon.Transform -xsl:xslt/quickview.xsl -o:data/quickview.html -it:START > LOG/LOG_QUICKVIEW 2>&1
        java -Xms512m -Xmx1536m net.sf.saxon.Transform -xsl:xslt/quickview.xsl -o:data/quickview.html -it:START > LOG/LOG_QUICKVIEW 2>&1 && cp data/quickview.html /Volumes/Documents/DCLP/data
    -->

    <xsl:param name="datadir">../data/</xsl:param>
    <xsl:template name="START">
        <xsl:message>trying to use datadir="<xsl:value-of select="$datadir"/>"</xsl:message>
        <html>
            <head>
                <title>DCLP metadata quickview</title>
                <style type="text/css">
                    body, table {
                      font-size: 8pt;
                    }
                    th {
                      background-color: lightsteelblue;
                    }
                    th.drawings{
                      width: 200px;
                    }
                    td {
                      border-bottom: solid 1px lightsteelblue;
                      vertical-align: top;
                    }
                    a, a:hover, a:link {
                      color: steelblue;
                    }
                    ul {
                      list-style-type: none;
                      padding: 0;
                    }
                </style>
            </head>
            <body>
                <table cellspacing="0">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>TM</th>
                            <th>LDAB</th>
                            <th>Editionsfragment Ids</th>
                            <th>Inventory number</th>
                            <th>Material</th>
                            <th class="drawings">Drawings</th>
                            <th>Date</th>
                            <th>Reference edition</th>
                            <th>Ancient work</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:variable name="query">
                            <xsl:text></xsl:text><xsl:value-of select="$datadir"/>?recurse=yes;select=*.xml<xsl:text></xsl:text>
                        </xsl:variable>
                        <xsl:message>query="<xsl:value-of select="$query"/>"</xsl:message>
                        <xsl:for-each select="collection($query)">
                        <!-- <xsl:for-each select="collection('file:///Users/paregorios/Documents/files/D/dclp/dev/dclpxsltbox/data/?recurse=yes;validation=strip;select=*.xml')"> -->
                            <xsl:message>each: <xsl:value-of select="document-uri(.)"/></xsl:message>
                            <xsl:variable name="doc" select="."/>
                            <tr>
                                <td>
                                    <a href="meta/{ceiling(tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='TM'] div 1000)}/{tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='TM']}.xml"><xsl:value-of select="tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:titleStmt[1]/tei:title[1]"/></a>
                                </td>
                                <td>
                                    <a href="http://www.trismegistos.org/text/{tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='TM']}"><xsl:value-of select="string-join(tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='TM'], ', ')"/></a>
                                </td>
                                <td>
                                    <a href="http://www.trismegistos.org/ldab/text.php?quick={tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='LDAB']}"><xsl:value-of select="string-join(tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='LDAB'][1], ', ')"/></a>
                                </td>
                                <td>
                                    <xsl:value-of select="string-join(tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type='herc-fr'], ', ')"/>
                                </td>
                                <td>
                                    <xsl:value-of select="string-join(tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:msDesc[1]/tei:msIdentifier[1]//tei:idno[@type='invNo'], ', ')"/>
                                </td>
                                <td>
                                    <xsl:value-of select="tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:msDesc[1]/tei:physDesc[1]/tei:objectDesc[1]/tei:supportDesc[1]/tei:support[1]/tei:material[1]"/>                                    
                                </td>
                                <td>
                                    <xsl:if test="tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:msDesc[1]/tei:additional[1]/tei:adminInfo[1]/tei:custodialHist[1]/tei:custEvent">
                                        <ul>
                                            <xsl:for-each select="tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:msDesc[1]/tei:additional[1]/tei:adminInfo[1]/tei:custodialHist[1]/tei:custEvent">                                        
                                                <li>
                                                    <xsl:choose>
                                                        <xsl:when test="tei:ptr/@target">
                                                            <a href="{tei:ptr/@target}">
                                                                <xsl:if test="tei:forename">
                                                                    <xsl:value-of select="tei:forename" />
                                                                    <xsl:if test="tei:surname">
                                                                        <xsl:text> </xsl:text>
                                                                    </xsl:if>
                                                                </xsl:if>
                                                                <xsl:if test="tei:surname">
                                                                    <xsl:value-of select="tei:surname" />
                                                                </xsl:if>
                                                            </a>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:if test="tei:forename">
                                                                <xsl:value-of select="tei:forename" />
                                                                <xsl:if test="tei:surname">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                            </xsl:if>
                                                            <xsl:if test="tei:surname">
                                                                <xsl:value-of select="tei:surname" />
                                                            </xsl:if>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    
                                                    <xsl:if test="@from or @to">
                                                        <xsl:text>, </xsl:text>
                                                        <xsl:if test="@from">
                                                            <xsl:value-of select="@from" />
                                                            <xsl:if test="@to">
                                                                <xsl:text> - </xsl:text>
                                                            </xsl:if>
                                                        </xsl:if>
                                                        <xsl:if test="@to">
                                                            <xsl:value-of select="@to" />
                                                        </xsl:if>
                                                    </xsl:if>
                                                    <xsl:if test="@corresp">
                                                        <xsl:text> (</xsl:text>
                                                        <xsl:for-each select="tokenize(@corresp, ' ')">
                                                            <xsl:variable name="id" select="substring-after(., '#')"/>
                                                            <xsl:value-of select="$doc/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:msDesc[1]/tei:msIdentifier[1]//tei:idno[@type='invNo'][@xml:id=$id]" />
                                                            <xsl:text> </xsl:text>
                                                        </xsl:for-each>
                                                        <xsl:text>)</xsl:text>
                                                    </xsl:if>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </xsl:if>
                                </td>
                                <td>
                                    <xsl:value-of select="tei:TEI/tei:teiHeader[1]/tei:revisionDesc[1]/tei:change[1]/@when" />
                                </td>
                                <td>
                                    <xsl:if test="tei:TEI/tei:text[1]/tei:body[1]/tei:div[@type='bibliography'][@subtype='referenceEdition']/tei:listBibl[1]/tei:bibl[@type='publication'][@subtype='reference']">
                                        <ul>
                                            <xsl:for-each select="tei:TEI/tei:text[1]/tei:body[1]/tei:div[@type='bibliography'][@subtype='referenceEdition']/tei:listBibl[1]/tei:bibl[@type='publication'][@subtype='reference']">
                                                <li>
                                                    <xsl:if test="tei:title or tei:author or tei:editor or tei:date">
                                                        <a href="biblio/84/{replace(tei:ptr/@target, '[^\d]', '')}.xml">
                                                            <xsl:if test="tei:title">
                                                                <xsl:value-of select="tei:title" />
                                                            </xsl:if>
                                                            <xsl:if test="tei:editor/tei:forename or tei:editor/tei:surname">
                                                                <xsl:text>, </xsl:text>
                                                                <xsl:if test="tei:editor/tei:forename">
                                                                    <xsl:value-of select="tei:editor/tei:forename" />
                                                                    <xsl:if test="tei:editor/tei:surname">
                                                                        <xsl:text> </xsl:text>
                                                                    </xsl:if>
                                                                </xsl:if>
                                                                <xsl:if test="tei:editor/tei:surname">
                                                                    <xsl:value-of select="tei:editor/tei:surname" />
                                                                </xsl:if>
                                                            </xsl:if>
                                                            
                                                            <xsl:if test="tei:author/tei:forename or tei:author/tei:surname">
                                                                <xsl:text>, </xsl:text>
                                                                <xsl:if test="tei:author/tei:forename">
                                                                    <xsl:value-of select="tei:author/tei:forename" />
                                                                    <xsl:if test="tei:author/tei:surname">
                                                                        <xsl:text> </xsl:text>
                                                                    </xsl:if>
                                                                </xsl:if>
                                                                <xsl:if test="tei:author/tei:surname">
                                                                    <xsl:value-of select="tei:author/tei:surname" />
                                                                </xsl:if>
                                                            </xsl:if>
                                                            
                                                            <xsl:if test="tei:date">
                                                                <xsl:text>, </xsl:text>
                                                                <xsl:value-of select="tei:date" />
                                                            </xsl:if>
                                                        </a>
                                                    </xsl:if>
                                                    <xsl:if test="count(tei:biblScope) > 1">
                                                        <xsl:text> (</xsl:text>
                                                        <xsl:for-each select="tei:biblScope[@type='fragment']">
                                                            <xsl:variable name="id" select="substring-after(@corresp, '#')" />
                                                            <xsl:value-of select="$doc/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:msDesc[1]/tei:msIdentifier[1]//tei:idno[@type='invNo'][@xml:id=$id]" />
                                                            <xsl:if test="position() != last()">
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                        <xsl:text>)</xsl:text>
                                                    </xsl:if> 
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </xsl:if>
                                </td>
                                <td>
                                    <xsl:if test="tei:TEI/tei:text[1]/tei:body[1]/tei:div[@type='bibliography'][@subtype='ancientEdition']/tei:listBibl[1]/tei:bibl[@type='publication'][@subtype='ancient']">
                                        <ul>
                                            <xsl:for-each select="tei:TEI/tei:text[1]/tei:body[1]/tei:div[@type='bibliography'][@subtype='ancientEdition']/tei:listBibl[1]/tei:bibl[@type='publication'][@subtype='ancient']">
                                                <li>
                                                    
                                                    <xsl:if test="tei:author">
                                                        <b>
                                                            <xsl:choose>
                                                                <xsl:when test="tei:author/@ref">
                                                                    <a href="{tei:author/@ref}"><xsl:value-of select="normalize-space(tei:author)" /></a>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="normalize-space(tei:author)" />
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                            
                                                            <xsl:if test="tei:author/tei:certainty[@cert='low']">
                                                                <xsl:text> </xsl:text><span title="certainty low"><xsl:text>(?)</xsl:text></span>
                                                            </xsl:if>
                                                            <xsl:if test="tei:author/tei:certainty[@cert='unknown']">
                                                                <xsl:text> </xsl:text><span title="author certainty unknown"><xsl:text>(???)</xsl:text></span>
                                                            </xsl:if>
                                                            <xsl:if test="tei:title[@type='main'][@level='m'] or tei:biblScope[@type='vol']">
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:if>
                                                        </b>
                                                    </xsl:if>
                                                    
                                                    <xsl:if test="tei:title[@type='main'][@level='m'] or tei:biblScope[@type='vol']">
                                                        <i>
                                                            <xsl:if test="tei:title[@type='main'][@level='m']">
                                                                <xsl:choose>
                                                                    <xsl:when test="tei:title[@type='main'][@level='m']/@ref">
                                                                        <a href="{tei:title[@type='main'][@level='m']/@ref}">
                                                                            <xsl:value-of select="tei:title[@type='main'][@level='m']" />
                                                                        </a>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:value-of select="tei:title[@type='main'][@level='m']" />
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                                
                                                            </xsl:if>
                                                            <xsl:if test="tei:title/tei:certainty[@cert='low']">
                                                                <xsl:text> </xsl:text><span title="certainty low"><xsl:text>(?)</xsl:text></span>
                                                            </xsl:if>
                                                            <xsl:if test="tei:title/tei:certainty[@cert='unknown']">
                                                                <xsl:text> </xsl:text><span title="title certainty unknown"><xsl:text>(???)</xsl:text></span>
                                                            </xsl:if>
                                                            <xsl:if test="tei:biblScope[@type='vol']">
                                                                <xsl:if test="tei:title[@type='main'][@level='m']">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                                <xsl:value-of select="tei:biblScope[@type='vol']" />
                                                                <xsl:if test="tei:biblScope[@type='vol']/tei:certainty[@cert='low']">
                                                                    <xsl:text> </xsl:text><span title="certainty low"><xsl:text>(?)</xsl:text></span>
                                                                </xsl:if>
                                                                <xsl:if test="tei:biblScope[@type='vol']/tei:certainty[@cert='unknown']">
                                                                    <xsl:text> </xsl:text><span title="volume certainty unknown"><xsl:text>(???)</xsl:text></span>
                                                                </xsl:if>
                                                            </xsl:if>
                                                        </i>
                                                    </xsl:if>

                                                    <xsl:if test="@corresp">
                                                        <xsl:text> (</xsl:text>
                                                        <xsl:for-each select="tokenize(@corresp, ' ')">
                                                            <xsl:variable name="id" select="substring-after(., '#')" />
                                                            <xsl:value-of select="$doc/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:msDesc[1]/tei:msIdentifier[1]//tei:idno[@type='invNo'][@xml:id=$id]" />
                                                            <xsl:if test="position() != last()">
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                        <xsl:text>)</xsl:text>
                                                    </xsl:if>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </xsl:if>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
