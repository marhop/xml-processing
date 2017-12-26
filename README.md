# xml-processing

Examples for XML processing in different programming languages.

The exercises below are simple instances of common real-world XML processing
tasks: selection of elements, modification of element content, modification of
the XML tree and validation against an XML schema. The [example XML
file](xml/example.xml) and the [underlying schema](xml/gtr_dc.xsd) can be
found in the xml directory.

# Exercises

## Exercise 1

Print a list of all leaf node creators and titles, i.e., all `content/creator`
and `content/title` children of `node` elements that contain no other `node`
elements as children. Each item should be a line of the form "creator, title".

## Exercise 2

Same as exercise 1, but consider the case where some leaf nodes have no
creator element. Search their ancestors until a creator element is found and
print that instead.

## Exercise 3

Make the content of all `title` elements uppercase. Print the resulting XML
document.

## Exercise 4

Add a new item to the end of the "A Song of Ice and Fire" section with title
"A Feast for Crows" and date "2005". Print the resulting XML document.

## Exercise 5

Remove the "Programming Books" section. Print the resulting XML document.

## Exercise 6

Validate the XML document. Keep in mind that the schema file references
additional external schema files that have to be retrieved from the internet,
so internet access is required for validation.
