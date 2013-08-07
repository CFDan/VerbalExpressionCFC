<cfcomponent displayname="VerbalExpression">
	<cfset variables.prefixes = "">
	<cfset variables.source = "">
	<cfset variables.suffixes = "">
	<cfset variables.pattern = "">
	
	<cfset variables.javaPattern = createObject( "java" , "java.util.regex.Pattern" )>
	
	<cfset variables.modifiers = variables.javaPattern.MULTILINE>
	
	<!--- Temp --->
	<cfset variables.name = "">
	
	<!--- Main Functions --->
	
	<cffunction name="sanitize" returntype="string" access="private">
		<cfargument name="value" required="No" type="string" default="">
		<cfif LEN( ARGUMENTS.value ) EQ "">
			<cfreturn ARGUMENTS.value>
		</cfif>
		<cfreturn variables.javaPattern.quote( ARGUMENTS.value )>
	</cffunction>
		
	<cffunction name="add" returntype="VerbalExpression" access="public">
		<cfargument name="value" type="string" required="No" default="">
		
		<cfif variables.source NEQ "">
			<cfset variables.source = variables.source & ARGUMENTS.value>
		<cfelse>
			<cfset variables.source = ARGUMENTS.value>
		</cfif>
				
		<cfif variables.source NEQ "">
			<cfset LOCAL.p = variables.javaPattern.compile( variables.prefixes & variables.source & variables.suffixes, javacast( "int", variables.modifiers ) )>
			<cfset variables.pattern = LOCAL.p.pattern()>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="startOfLine" returntype="VerbalExpression" access="public">
		<cfargument name="enable" type="boolean" required="No" default="true">
		
		<cfif ARGUMENTS.enable>
			<cfset variables.prefixes = "^">
		<cfelse>
			<cfset variables.prefixes = "">
		</cfif>
		
        <cfset this.add("")>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="endOfLine" returntype="VerbalExpression" access="public">
		<cfargument name="enable" type="boolean" required="No" default="true">
		
		<cfif ARGUMENTS.enable>
			<cfset variables.suffixes = "$">
		<cfelse>
			<cfset variables.suffixes = "">
		</cfif>
		
        <cfset this.add("")>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="then" returntype="VerbalExpression" access="public">
		<cfargument name="value" type="string" required="No" default="">
		
		<cfset ARGUMENTS.value = sanitize( ARGUMENTS.value )>
		<cfset this.add( "(" & ARGUMENTS.value & ")" )>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="find" returntype="VerbalExpression" access="public">
		<cfargument name="value" type="string" required="No" default="">
				
		<cfset this.then( ARGUMENTS.value )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="maybe" returntype="VerbalExpression" access="public">
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfset ARGUMENTS.value = sanitize( ARGUMENTS.value )>		
		<cfset this.add( "(" & ARGUMENTS.value & ")?" )>		
		
		<cfreturn this>
	</cffunction>
	
    <cffunction name="anything" returntype="VerbalExpression" access="public">				
		<cfset this.add( "(.*)" )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="anythingBut" returntype="VerbalExpression" access="public">				
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfset ARGUMENTS.value = sanitize( ARGUMENTS.value )>
		
		<cfset this.add( "([^" & ARGUMENTS.value & "]*)" )>		
		
		<cfreturn this>
	</cffunction>
	
    <cffunction name="something" returntype="VerbalExpression" access="public">				
		<cfset this.add( "(.+)" )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="somethingBut" returntype="VerbalExpression" access="public">				
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfset ARGUMENTS.value = sanitize( ARGUMENTS.value )>
		
		<cfset this.add( "([^" & ARGUMENTS.value & "]+)" )>		
		
		<cfreturn this>
	</cffunction>
		
	<cffunction name="lineBreak" returntype="VerbalExpression" access="public">				
		<cfset this.add( "(\n|(\r\n))" )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="br" returntype="VerbalExpression" access="public">				
		<cfset this.lineBreak()>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="tab" returntype="VerbalExpression" access="public">				
		<cfset this.add( "\t" )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="word" returntype="VerbalExpression" access="public">				
		<cfset this.add( "\w+" )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="anyOf" returntype="VerbalExpression" access="public">				
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfset ARGUMENTS.value = sanitize( ARGUMENTS.value )>
		
		<cfset this.add( "[" & ARGUMENTS.value & "]" )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="any" returntype="VerbalExpression" access="public">				
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfset this.anyOf( ARGUMENTS.value )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="withAnyCase" returntype="VerbalExpression" access="public">				
		<cfargument name="value" type="string" required="No" default="">		
				
		<cfset this.add( "(?i)" & ARGUMENTS.value)>		
		
		<cfreturn this>
	</cffunction>
	
	
	
	
	<cffunction name="addModifier" returntype="VerbalExpression" access="public">				
		<cfargument name="modifier" type="string" required="No" default="">		
		
		<cfif ARGUMENTS.modifier EQ "u">
			<cfif compare( ARGUMENTS.modifier , "u" ) EQ 0>
				<cfset ARGUMENTS.modifier = "lcaseU">
			<cfelse>
				<cfset ARGUMENTS.modifier = "ucaseU">
			</cfif>
		</cfif>
		
		<cfswitch expression="#ARGUMENTS.modifier#">
			<cfcase value="d">
				<cfset variables.modifiers += variables.javaPattern.UNIX_LINES>
			</cfcase>
			<cfcase value="i">
				<cfset variables.modifiers += variables.javaPattern.CASE_INSENSITIVE>
				<!--- Hack for Java Pattern not respecting CASE_INSENSITIVE flag --->
				<cfset variables.prefixes &= "(?i)">
				<cfset this.add( "")>
			</cfcase>
			<cfcase value="x">
				<cfset variables.modifiers += variables.javaPattern.COMMENTS>
			</cfcase>
			<cfcase value="m">
				<cfset variables.modifiers += variables.javaPattern.MULTILINE>				
			</cfcase>
			<cfcase value="s">
				<cfset variables.modifiers += variables.javaPattern.DOTALL>
				<!--- Hack for Java Pattern not respecting CASE_INSENSITIVE flag --->
				<cfset variables.prefixes &= "(?s)">
				<cfset this.add("")>
			</cfcase>
			<cfcase value="lcaseU">
				<cfset variables.modifiers += variables.javaPattern.UNICODE_CASE>
			</cfcase>
			<cfcase value="ucaseU">
				<cfset variables.modifiers += variables.javaPattern.UNICODE_CHARACTER_CLASS>
			</cfcase>
		</cfswitch>
		
		<cfset this.add("")>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="removeModifier" returntype="VerbalExpression" access="public">				
		<cfargument name="modifier" type="string" required="No" default="">		
		
		<cfif ARGUMENTS.modifier EQ "u">
			<cfif compare( ARGUMENTS.modifier , "u" ) EQ 0>
				<cfset ARGUMENTS.modifier = "lcaseU">
			<cfelse>
				<cfset ARGUMENTS.modifier = "ucaseU">
			</cfif>
		</cfif>
		
		<cfswitch expression="#ARGUMENTS.modifier#">
			<cfcase value="d">
				<cfset variables.modifiers -= variables.javaPattern.UNIX_LINES>
			</cfcase>
			<cfcase value="i">
				<cfset variables.modifiers -= variables.javaPattern.CASE_INSENSITIVE>
				<!--- Hack for Java Pattern not respecting CASE_INSENSITIVE flag --->
				<cfset variables.prefixes = replaceNoCase( variables.prefixes , "(?iu)" , "" , "ALL" )>
				<cfset this.add( "")>
			</cfcase>
			<cfcase value="x">
				<cfset variables.modifiers -= variables.javaPattern.COMMENTS>
			</cfcase>
			<cfcase value="m">
				<cfset variables.modifiers -= variables.javaPattern.MULTILINE>
			</cfcase>
			<cfcase value="s">
				<cfset variables.modifiers -= variables.javaPattern.DOTALL>
				<!--- Hack for Java Pattern not respecting CASE_INSENSITIVE flag --->
				<cfset variables.prefixes = replaceNoCase( variables.prefixes , "(?s)" , "" , "ALL" )>
				<cfset this.add("")>				
			</cfcase>
			<cfcase value="lcaseU">
				<cfset variables.modifiers -= variables.javaPattern.UNICODE_CASE>
			</cfcase>
			<cfcase value="ucaseU">
				<cfset variables.modifiers -= variables.javaPattern.UNICODE_CHARACTER_CLASS>
			</cfcase>
		</cfswitch>
		
		<cfset this.add("")>
		
		<cfreturn this>
	</cffunction>
						
	<cffunction name="test" returntype="String" access="public">
		<cfargument name="toTest" type="string" required="Yes">
		
		<cfset this.add("")>		
		
		<cfreturn variables.javaPattern.matches( variables.pattern , ARGUMENTS.toTest )>
	</cffunction>
	
    <cffunction name="toString" returntype="String" access="public">
		<cfset this.add("")>		
		
		<cfreturn variables.pattern.toString()>
	</cffunction>
	
	<cffunction name="searchOneLine" returntype="VerbalExpression" access="public">
		<cfargument name="enable" type="boolean" required="No" default="true">
		
		<cfif ARGUMENTS.enable>
			<cfset removeModifier("m")>
		<cfelse>
			<cfset addModifier("m")>
		</cfif>
		
        <cfset this.add("")>
		
		<cfreturn this>
	</cffunction>
	
	<!--- Test Functions --->	
	<cffunction name="AddValue" returntype="VerbalExpression" access="public">
		<cfargument name="val" type="string" required="Yes">
		
		<cfset variables.name = listAppend( variables.name , ARGUMENTS.val )>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="ToStringValue" returntype="String" access="public">
				
		<cfreturn variables.name>
	</cffunction>
	
	<cffunction name="Debug" output="Yes" access="public">
		<cfdump var="#variables#">
	</cffunction>
	
</cfcomponent>