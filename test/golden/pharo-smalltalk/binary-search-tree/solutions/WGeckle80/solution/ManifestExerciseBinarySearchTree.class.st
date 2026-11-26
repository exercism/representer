"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestExerciseBinarySearchTree',
	#superclass : 'PackageManifest',
	#category : 'Exercise@BinarySearchTree-Manifest',
	#package : 'Exercise@BinarySearchTree',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestExerciseBinarySearchTree class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#BinarySearchTree #treeData: #false)) #'2024-07-23T13:48:04.799747-04:00') )
]
