# ColdFusion VerbalExpressions

A ColdFusion implementation of [VerbalExpressions](https://github.com/VerbalExpressions/JSVerbalExpressions) based heavily on the [Java implementation](https://github.com/VerbalExpressions/JavaVerbalExpressions)

# Usage

~~~
<cfset ve = new VerbalExpression()>
<cfset ve.startOfLine().then( "http" ).maybe( "s" ).then( "://" ).maybe( "www." ).anythingBut( " " ).endOfLine()>

<cfset LOCAL.matches = ve.test( "https://www.google.com/" )>
~~~

# Notes

There seems to be a slight bug in the Pattern class in the Java ColdFusion 9 uses which ignores and modifiers added as flags so I've worked around it by putting the modifiers in using (modifierChar+) at the start of the pattern.

