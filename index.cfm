<!----
Java Source : https://github.com/VerbalExpressions/JavaVerbalExpressions/blob/master/VerbalExpression.java
---->

<h3>Verbal Expression</h3>

<cfset vb = new VerbalExpression()>

<cfset x = vb.add("daniel").range("A","Z","a","z").range(1,9).range(1,9).range(1,9).test("danielM123")>

<cfoutput>#vb.toString()#:#x#</cfoutput>
<cfabort>

<cfset vb.startOfLine().add("Dan").anything().add("Mackey").multiple("x").then("rocks").addModifier("s").removeModifier("m")>

<cfsavecontent variable="LOCAL.testString">Dan
Mackeyxxxrocks</cfsavecontent>

<cfset LOCAL.matches = vb.test( LOCAL.testString )>

<cfdump var="#LOCAL.matches#">

<h5>Test String</h5>
<cfoutput>
<pre style="border:1px solid red">#LOCAL.testString#</pre>
</cfoutput>

<h4>Regex</h4>
<cfoutput>
<pre>
	vb.toString() : #vb.toString()#
</pre>
</cfoutput>

<h4>Replace</h4>

<cfset replaceMe = "Replace the bird ok another rabbit">

<cfset result = new VerbalExpression().find( "bird" ).anything().then("ok").replace( replaceMe ,"duck")>

<cfoutput>#result#</cfoutput>

<h3>Url</h3>
<cfset vb = new VerbalExpression()>
<cfset vb.startOfLine().then( "http" ).maybe( "s" ).then( "://" ).maybe( "www." ).anythingBut( " " ).endOfLine()>

<cfset LOCAL.matches = vb.test( "https://www.google.com/" )>

<cfdump var="#LOCAL.matches#">

<hr>

<h4>Debug</h4>
<cfset vb.Debug()>
<hr>
