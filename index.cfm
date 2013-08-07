<!----
Java Source : https://github.com/VerbalExpressions/JavaVerbalExpressions/blob/master/VerbalExpression.java
---->

<h3>Verbal Expression</h3>

<cfset vb = new VerbalExpression()>
<cfset vb.startOfLine().add("Dan").anything().add("Mackey").addModifier("m").addModifier("s")>

<cfsavecontent variable="LOCAL.testString">Dan
Mackey</cfsavecontent>

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

<hr>

<h4>Debug</h4>
<cfset vb.Debug()>
<hr>

<h3>Url</h3>
<cfset vb = new VerbalExpression()>
<cfset vb.startOfLine().then( "http" ).maybe( "s" ).then( "://" ).maybe( "www." ).anythingBut( " " ).endOfLine()>

<cfset LOCAL.matches = vb.test( "https://www.google.com/" )>

<cfdump var="#LOCAL.matches#">