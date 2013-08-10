<cfcomponent displayname="VerbalExpression">
	<cfset variables.prefixes = "">
	<cfset variables.source = "">
	<cfset variables.suffixes = "">
	<cfset variables.pattern = "">
	
	<cfset variables.javaPattern = createObject( "java" , "java.util.regex.Pattern" )>

	<cfset variables.MODIFIER_UNIX_LINES = "(?d)">
	<cfset variables.MODIFIER_CASE_INSENSITIVE = "(?i)"> 
	<cfset variables.MODIFIER_COMMENTS = "(?x)"> 
	<cfset variables.MODIFIER_MULTILINE = "(?m)"> 
	<cfset variables.MODIFIER_DOTALL = "(?s)"> 
	<cfset variables.MODIFIER_UNICODE_CASE = "(?u)"> 
	<cfset variables.MODIFIER_UNICODE_CHARACTER_CLASS = "(?U)">
	
	<cfset variables.modifiers = [variables.MODIFIER_MULTILINE]>
		
	<!--- Main Private Functions --->	
	<cffunction name="sanitize" returntype="string" access="private">
		<cfargument name="value" required="No" type="string" default="">
		<cfif LEN( ARGUMENTS.value ) EQ "">
			<cfreturn ARGUMENTS.value>
		</cfif>
		<cfreturn variables.javaPattern.quote( ARGUMENTS.value )>
	</cffunction>
	
	<cffunction name="editModifier" returntype="VerbalExpression" access="private">				
		<cfargument name="modifier" type="string" required="No" default="">		
		<cfargument name="action" type="string" default="add">
		
		<cfset LOCAL.modifierToEdit = "">
		
		<cfif ARGUMENTS.modifier EQ "u">
			<cfif compare( ARGUMENTS.modifier , "u" ) EQ 0>
				<cfset ARGUMENTS.modifier = "lcaseU">
			<cfelse>
				<cfset ARGUMENTS.modifier = "ucaseU">
			</cfif>
		</cfif>
		
		<cfswitch expression="#ARGUMENTS.modifier#">
			<cfcase value="d">
				<cfset LOCAL.modifierToEdit = variables.MODIFIER_UNIX_LINES>
			</cfcase>
			<cfcase value="i">				
				<cfset LOCAL.modifierToEdit = variables.MODIFIER_CASE_INSENSITIVE>
			</cfcase>
			<cfcase value="x">
				<cfset LOCAL.modifierToEdit = variables.MODIFIER_COMMENTS>
			</cfcase>
			<cfcase value="m">
				<cfset LOCAL.modifierToEdit = variables.MODIFIER_MULTILINE>	
			</cfcase>
			<cfcase value="s">
				<cfset LOCAL.modifierToEdit = variables.MODIFIER_DOTALL>
			</cfcase>
			<cfcase value="lcaseU">
				<cfset LOCAL.modifierToEdit = variables.MODIFIER_UNICODE_CASE>
			</cfcase>
			<cfcase value="ucaseU">
				<cfset LOCAL.modifierToEdit = variables.MODIFIER_UNICODE_CHARACTER_CLASS>
			</cfcase>
		</cfswitch>
		
		<cfif ARGUMENTS.action EQ "remove">
			<cfif LEN( LOCAL.modifierToEdit ) AND arrayFind( variables.modifiers , LOCAL.modifierToEdit )>
				<cfset arrayDelete( variables.modifiers , LOCAL.modifierToEdit )>
				<cfset this.add( "")>
			</cfif>
		<cfelse>
			<cfif LEN( LOCAL.modifierToEdit ) AND NOT arrayFind( variables.modifiers , LOCAL.modifierToEdit )>
				<cfset arrayAppend( variables.modifiers , LOCAL.modifierToEdit )>
				<cfset this.add( "")>
			</cfif>
		</cfif>
				
		<cfreturn this>
	</cffunction>
	
	<!--- Main Public Functions --->
		
	<cffunction name="add" returntype="VerbalExpression" access="public">
		<cfargument name="value" type="string" required="No" default="">
		
		<cfif variables.source NEQ "">
			<cfset variables.source = variables.source & ARGUMENTS.value>
		<cfelse>
			<cfset variables.source = ARGUMENTS.value>
		</cfif>
				
		<cfif variables.source NEQ "">
			<cfset LOCAL.p = variables.javaPattern.compile( arrayToList( variables.modifiers , "" ) & variables.prefixes & variables.source & variables.suffixes )>
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
	
	<cffunction name="replace" returntype="string" access="public" output="No">
		<cfargument name="source" type="string" required="No" default="">				
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfset LOCAL.result = ARGUMENTS.value>
		
		<cfset this.add("")>
		
		<cfset LOCAL.result = ARGUMENTS.source.replaceAll( variables.pattern, ARGUMENTS.value )>
				
		<cfreturn LOCAL.result>
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
	
	<cffunction name="number" returntype="VerbalExpression" access="public">				
		<cfset this.add( "[0-9]+" )>		
		
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
	
	
	<cffunction name="range" returntype="VerbalExpression" access="public" output="No">						
		<cfset LOCAL.numberOfKeys = structCount( ARGUMENTS )>
		
		<cfset LOCAL.value = "[">
				
		<cfloop from="1" to="#LOCAL.numberOfKeys#" index="LOCAL.key" step="2">
			<cfset LOCAL._to = LOCAL.key+1>
			<cfif NOT structKeyExists( ARGUMENTS , LOCAL._to )>
				<cfbreak>
			</cfif>
			<cfset LOCAL.from = ARGUMENTS[ LOCAL.key ]>
			<cfset LOCAL.to = ARGUMENTS[ LOCAL._to ]>			
			<cfset LOCAL.value &= LOCAL.from & "-" & LOCAL.to>
		</cfloop>
		<cfset LOCAL.value &= "]">
		
		<cfset this.add( LOCAL.value )>
		
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="withAnyCase" returntype="VerbalExpression" access="public">				
		<cfargument name="enable" type="boolean" required="No" default="true">
		
		<cfif ARGUMENTS.enable>
			<cfset addModifier("i")>
		<cfelse>
			<cfset removeModifier("i")>
		</cfif>		
		
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="dotall" returntype="VerbalExpression" access="public">				
		<cfargument name="enable" type="boolean" required="No" default="true">
		
		<cfif ARGUMENTS.enable>
			<cfset addModifier("s")>
		<cfelse>
			<cfset removeModifier("s")>
		</cfif>		
		
		<cfreturn this>
	</cffunction>
		
	<cffunction name="addModifier" returntype="VerbalExpression" access="public">				
		<cfargument name="modifier" type="string" required="No" default="">		
		
		<cfreturn editModifier(
			modifier	=	ARGUMENTS.modifier,
			action		=	"add"
		)>
	</cffunction>
	
	<cffunction name="removeModifier" returntype="VerbalExpression" access="public">				
		<cfargument name="modifier" type="string" required="No" default="">		
		
		<cfreturn editModifier(
			modifier	=	ARGUMENTS.modifier,
			action		=	"remove"
		)>
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
	
	<cffunction name="multiple" returntype="VerbalExpression" access="public">				
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfset ARGUMENTS.value = sanitize( ARGUMENTS.value )>
		
		<cfswitch expression="#LEFT( ARGUMENTS.value , 1 )#">
			<cfcase value="*">
			
			</cfcase>
			<cfcase value="+">
				<cfbreak>
			</cfcase>
			<cfdefaultcase>
				<cfset ARGUMENTS.value &= "+">
			</cfdefaultcase>
		</cfswitch>
		
		<cfset this.add( ARGUMENTS.value )>		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="or" returntype="VerbalExpression" access="public">				
		<cfargument name="value" type="string" required="No" default="">		
		
		<cfif NOT find( "(" , variables.prefixes )>
			<cfset variables.prefixes &= "(">
		</cfif>
		
		<cfif NOT find( ")" , variables.suffixes )>
			<cfset variables.suffixes = ")" & variables.suffixes>
		</cfif>
				
		<cfset this.add( ")|(" )>		
		
		<cfif LEN( ARGUMENTS.value )>
			<cfset then( ARGUMENTS.value )>
		</cfif>
		
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
	
	
	<cffunction name="Debug" output="Yes" access="public">
		<cfdump var="#variables#">
	</cffunction>
	
</cfcomponent>