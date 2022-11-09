import (
  "encoding/json"
  "strings"
  "strconv"
)
#Predicate: {
  Data: string
  Timestamp: string
  ...
}

predicate: {
scanner: {
    result: {
    runs: [...{
        tool: {
        driver: {
            rules: [...{
            id: id
                properties: {
                "security-severity": string
                severityFloat: strconv.ParseFloat(properties."security-severity", 16)
                if severityFloat > 9.0 {
                    expectedError: "no error",
                    err: strings.Join(["Error: contains high severity vulnerability", id, properties."security-severity"], " ")
                    expectedError: err
                }
                }
            }]
        }
        }
    }]
    }
}
}
