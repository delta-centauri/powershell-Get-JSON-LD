# Retrieve URI
# Method 1: via user prompt 
# $uri = Read-Host -Prompt "Bitte URI angeben" # example: $uri = "https://www.fuw.ch/article/value-hat-den-haertetest-bestanden/"

# Method 2: via parameter
param([string]$uri)

# Retrieve Document
$result = Invoke-WebRequest -Uri $uri

# exit script if status header not 200
if ($result.StatusCode -notlike "200") {
    echo "HTTP Header Status Code not 200"
    Exit 1
}

# get parsed html
$parsedHtml = $result.ParsedHtml

# Get JS Scripts
$scripts = $parsedHtml.scripts

# check if scripts has json-ld and save its content in variable
[Bool]$found = 0
[String]$jsonld = ""
foreach ($ele in $scripts) { 
    if ($ele.type -like "application/ld+json") {
        echo "JSON-LD was found."
        $found = 1
        $jsonld = $ele.text
        break
    }
}
if (!$found) {
    echo "No JSON-LD found. Exit."
    exit 1
}

# echo json-ld
$jsonld

