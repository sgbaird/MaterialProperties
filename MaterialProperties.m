(* ::Package:: *)

(* ::Input::Initialization:: *)
BeginPackage["MaterialProperties`"];
MaterialProperties::usage="use the REST API to get materials data from materialsproject.org.  https://materialsproject.org/docs/api section 4.3.1 for list of available properties. This implementation has limited functionality (2020-09-02), so try out the website or direct API calls instead of this wrapper function via URLBuild, URLExecute, and Association Key Mapping (e.g. <|\"a\"->b|>[\"a\"]). You will also need to specify a personal key by updating the myKey value inside the MaterialProperties function and resaving MaterialProperties.nb as MaterialProperties.m in a $Path folder (change filetype to .m in dropdown). I recommend workflow/GetDataFromARESTfulAPI for some basic guidelines on accessing APIs.

Example usage:
	MaterialProperties[\"Fe3C\"] (*get material properties for \!\(\*SubscriptBox[\(Fe\), \(3\)]\)C*)
	MaterialProperties[\"Fe3C\", \"spacegroup\"] (*get the spacegroup properties of \!\(\*SubscriptBox[\(Fe\), \(3\)]\)C*)
	MaterialProperties[\"Fe3C\", \"spacegroup\", \"number\"] (*get the spacegroup number of \!\(\*SubscriptBox[\(Fe\), \(3\)]\)C*) 
	MaterialProperties[\"Fe3C\", \"\" ,\"\" , 0] (*get material properties for all database entries of \!\(\*SubscriptBox[\(Fe\), \(3\)]\)C*)
	MaterialProperties[\"Fe3C\", \"\" ,\"\" , 4] (*get material properties for the first 4 database entries of \!\(\*SubscriptBox[\(Fe\), \(3\)]\)C (or all entries, if # entries < 4);
	MaterialProperties[\"Fe3C\", \"spacegroup\", \"number\", 0] (*get a list of possible spacegroup numbers for \!\(\*SubscriptBox[\(Fe\), \(3\)]\)C*)

General URI format: Get https://www.materialsproject.org/rest/v2/materials/{material id, formula, or chemical system}/vasp/{property}?API_KEY=YOUR_API_KEY
";

Begin["Private`"];
MaterialProperties[formula_String,property_:"",subproperty_:"",requestedEntries_Integer:1]:=
Module[{urlRoot,myKey,requestURI,response,maxEntries,numEntries,propertyKey,subpropertyKey,out},
urlRoot="https://www.materialsproject.org/rest/v2/materials/";
myKey="ABC";
requestURI=URLBuild[{urlRoot,formula,"vasp",property},{"API_KEY"->myKey}];
response=URLExecute[requestURI,"rawJSON"];
maxEntries=Length@response;
If[requestedEntries==0, numEntries=maxEntries;, numEntries=Min[{maxEntries,requestedEntries}];];
If[property=="",propertyKey=Sequence[];,propertyKey=property;];
If[subproperty=="",subpropertyKey=Sequence[];,subpropertyKey=subproperty;];
out=Lookup[response,"response"][[#]][propertyKey][subpropertyKey]&/@Range[numEntries];
If[Length@out==1 &&requestedEntries==1 ,out[[1]],out]
];
End[]
EndPackage[]


(* ::Text:: *)
(*Code Graveyard*)


(* ::Input:: *)
(*(*MaterialProperties[formula_String,property_String]:=*)
(*Module[{urlRoot,myKey,requestURI,response},*)
(*urlRoot="https://www.materialsproject.org/rest/v2/materials/";*)
(*myKey="JHlWQRu5mpE4FC72";*)
(*requestURI=URLBuild[{urlRoot,formula,"vasp",property},{"API_KEY"->myKey}];*)
(*response=URLExecute[requestURI,"rawJSON"];*)
(*Lookup[response,"response"]\[LeftDoubleBracket]1\[RightDoubleBracket][property] (*take first response could be multiple entries*)*)
(*];*)
(**)
(*MaterialProperties[formula_String]:=*)
(*Module[{urlRoot,myKey,requestURI,response,property},*)
(*property="";*)
(*urlRoot="https://www.materialsproject.org/rest/v2/materials/";*)
(*myKey="JHlWQRu5mpE4FC72";*)
(*requestURI=URLBuild[{urlRoot,formula,"vasp",property},{"API_KEY"->myKey}];*)
(*response=URLExecute[requestURI,"rawJSON"];*)
(*Lookup[response,"response"]\[LeftDoubleBracket]1\[RightDoubleBracket](*take first response could be multiple entries*)*)
(*];*)
(**)
(*MaterialProperties[formula_String,]:=*)
(*Module[{urlRoot,myKey,requestURI,response,property},*)
(*property="";*)
(*urlRoot="https://www.materialsproject.org/rest/v2/materials/";*)
(*myKey="JHlWQRu5mpE4FC72";*)
(*requestURI=URLBuild[{urlRoot,formula,"vasp",property},{"API_KEY"->myKey}];*)
(*response=URLExecute[requestURI,"rawJSON"];*)
(*Lookup[response,"response"]\[LeftDoubleBracket]1\[RightDoubleBracket](*take first response could be multiple entries*)*)
(*];*)
(**)*)
