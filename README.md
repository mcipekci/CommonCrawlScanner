# CommonCrawlScanner
Tool for scanning CommonCrawl indexes for target and fetch related urls

# Requirements:

**JQ**: https://stedolan.github.io/jq/

**cURL**

# Usage:
**Syntax**: ./cc.sh target filter

**Target**: target domain e.g: google.com

**Filter**: optional not required, adds filter for commoncrawl, more info about filters on: [CDX-API](https://github.com/webrecorder/pywb/wiki/CDX-Server-API#api-reference)

# Examples:
**Direct scan**: ./cc.sh google.com
**Filter http status 500**: ./cc.sh google.com status:500

It will save output to current working directory as well.
