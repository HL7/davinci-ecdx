
~~~
{
    "resourceType": "Task",
...
  "input": [
        {
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
                        "code": "data-query"
                    }
                ]
            },
            "valueString": "Condition?patient=cdex-example-patient&clinical-status=active,recurrance,remission"
        },
        {
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
                        "code": "purpose-of-use"
                    }
                ]
            },
            "valueCodeableConcept": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
                        "code": "treatment-noe"
                    },
                    {
                        "system": "http://example.org/CodeSystem/POU",
                        "code": "some-other-treatment-purpose"
                    }
                ]
            }
        }
....
~~~