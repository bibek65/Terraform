#!/bin/bash

# Fetch CloudFront distribution ARNs tagged with "Bibek Cloud front"
output=$(aws resourcegroupstaggingapi get-resources --tag-filters 'Key=Name,Values=Bibek Cloud front' --resource-type-filters 'cloudfront' --tags-per-page 100)

# Extract ARNs from the output using grep and sed
arn=$(echo "$output" | grep -oP '"ResourceARN": "\K[^"]+' | sed 's:.*/::')

# Check if ARN is empty
if [ -z "$arn" ]; then
  echo "{\"arn\": \"\"}"  # Output empty JSON
else
  # Format the output as JSON
  echo "{\"arn\": \"$arn\"}"
fi
