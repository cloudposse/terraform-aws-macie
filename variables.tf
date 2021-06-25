variable "admin_org_account_enabled" {
  type        = bool
  description = "Whether to enable Amazon Macie administrator account for the organization."
  default     = true
}

variable "member" {
  type        = map(any)
  default     = {}
  description = <<-DOC
    The Member provides information about an individual account that's associated with your Amazon Macie account, typically a Macie administrator account.
      account_id:
        The AWS account ID for the account.
      email:
        The email address for the account.
      tags:
        A map of key-value pairs that specifies the tags to associate with the account in Amazon Macie.
      status:
        Specifies the status for the account.
        Possible values: `ENABLED`, `PAUSED`.
      invite:
        Whether to send an invitation to a member.
      invitation_message:
        A custom message to include in the invitation. 
        Amazon Macie adds this message to the standard content that it sends for an invitation.
      invitation_disable_email_notification:
        Whether to send an email notification to the root user of each account that the invitation will be sent to.    
  DOC
}

variable "custom_data_identifiers" {
  type        = list(any)
  default     = []
  description = <<-DOC
    A list of maps of custom data identifiers.
    A custom data identifier is a set of criteria that you defined to detect sensitive data in one or more data sources.
      regex:
        The regular expression (regex) that defines the pattern to match. 
        The expression can contain as many as 512 characters.
      keywords:
        An array that lists specific character sequences (keywords), one of which must be within proximity (`maximum_match_distance`) of the regular expression to match. 
        The array can contain as many as 50 keywords.
        Each keyword can contain 3 - 90 characters. Keywords aren't case sensitive.
      ignore_words:
        An array that lists specific character sequences (ignore words) to exclude from the results. 
        If the text matched by the regular expression is the same as any string in this array, Amazon Macie ignores it. 
        The array can contain as many as 10 ignore words. 
        Each ignore word can contain 4 - 90 characters.
      maximum_match_distance:
        The maximum number of characters that can exist between text that matches the regex pattern and the character sequences specified by the keywords array. 
        Macie includes or excludes a result based on the proximity of a keyword to text that matches the regex pattern. 
        The distance can be 1 - 300 characters. The default value is 50.
      name:
        A custom name for the custom data identifier.
      description:
        A custom description of the custom data identifier.
      tags:
        A map of key-value pairs that specifies the tags to associate with the custom data identifier. 
  DOC
}

variable "classification_jobs" {
  type        = list(any)
  default     = []
  description = <<-DOC
    A list of maps of Classification Jobs.
    The Classification Job Creation resource represents the collection of settings that define the scope and schedule for a classification job.
      name:
        A custom name for the job.
      description:
        A custom description of the job.
      tags:
        A map of key-value pairs that specifies the tags to associate with the job.
      sampling_percentage:
        The sampling depth, as a percentage, to apply when processing objects. 
        This value determines the percentage of eligible objects that the job analyzes.
      initial_run:
        Whether to analyze all existing, eligible objects immediately after the job is created.
      job_type:
        The schedule for running the job.
        If you specify `SCHEDULED` value, use the `schedule_frequency` property to define the recurrence pattern for the job.
        Possible values: `ONE_TIME`, `SCHEDULED`.
      job_status:
        The status for the job. 
        Possible values: `CANCELLED`, `RUNNING` and `USER_PAUSED`.
      custom_data_identifier_ids:
        The custom data identifiers to use for data analysis and classification.
        Conflicts with `custom_data_identifier_names`.
      custom_data_identifier_names:
        The custom data identifiers created by this module to use for data analysis and classification.
        Conflicts with `custom_data_identifier_ids`.
      schedule_frequency:
        daily_schedule:
          Specifies a daily recurrence pattern for running the job.
        weekly_schedule:
          Specifies a weekly recurrence pattern for running the job.
        monthly_schedule:
          Specifies a monthly recurrence pattern for running the job.
      s3_job_definition:
        The S3 buckets that contain the objects to analyze, and the scope of that analysis.
          bucket_definitions:
             An array of objects, one for each AWS account that owns buckets to analyze.
              account_id:
                The unique identifier for the AWS account that owns the buckets.
              buckets:
                An array that lists the names of the buckets.
      scoping:
        The property- and tag-based conditions that determine which objects to include or exclude from the analysis.
          excludes:
            The property- or tag-based conditions that determine which objects to exclude from the analysis.
               and:
                An array of conditions, one for each condition that determines which objects to include or exclude from the job.
                  simple_scope_term:
                    A property-based condition that defines a property, operator, and one or more values for including or excluding an object from the job.
                      comparator:
                        The operator to use in a condition. 
                        Possible values are: `EQ`, `GT`, `GTE`, `LT`, `LTE`, `NE`, `CONTAINS`, `STARTS_WITH`.
                      values:
                        An array that lists the values to use in the condition.
                      key:
                        The object property to use in the condition.
                  tag_scope_term:
                    A tag-based condition that defines the operator and tag keys or tag key and value pairs for including or excluding an object from the job.
                      comparator:
                        The operator to use in the condition.
                      tag_values:
                        The tag keys or tag key and value pairs to use in the condition.
                      key:
                        The tag key to use in the condition.
                      target:
                        The type of object to apply the condition to.
          includes:
            The property- or tag-based conditions that determine which objects to include in the analysis. 
               and:
                An array of conditions, one for each condition that determines which objects to include or exclude from the job.
                  simple_scope_term:
                    A property-based condition that defines a property, operator, and one or more values for including or excluding an object from the job.
                      comparator:
                        The operator to use in a condition. 
                        Possible values are: `EQ`, `GT`, `GTE`, `LT`, `LTE`, `NE`, `CONTAINS`, `STARTS_WITH`.
                      values:
                        An array that lists the values to use in the condition.
                      key:
                        The object property to use in the condition.
                  tag_scope_term:
                    A tag-based condition that defines the operator and tag keys or tag key and value pairs for including or excluding an object from the job.
                      comparator:
                        The operator to use in the condition.
                      tag_values:
                        The tag keys or tag key and value pairs to use in the condition.
                      key:
                        The tag key to use in the condition.
                      target:
                        The type of object to apply the condition to.
  DOC
}

variable "findings_filters" {
  type        = list(any)
  default     = []
  description = <<-DOC
    A list of maps of findings filters.
    The Findings Filter resource represents an individual filter that you created and saved to view, analyze, and manage findings.
      name:
        A custom name for the filter.
      description:
        A custom description of the filter.
      action
        The action to perform on findings that meet the filter criteria.
        Possible values: `ARCHIVE`, `NOOP`.
      position:
        The position of the filter in the list of saved filters on the Amazon Macie console. 
        This value also determines the order in which the filter is applied to findings, relative to other filters that are also applied to the findings.
      tags:
        A map of key-value pairs that specifies the tags to associate with the filter.
      finding_criteria:
        The criteria to use to filter findings.
        A list of maps with required key `field` and condition (`eq_exact_match`, `eq`, `neq`, `lt`, `lte`, `gt`, `gte`).
          field:
            The name of the field to be evaluated.
          eq_exact_match:
            The value for the property exclusively matches (equals an exact match for) all the specified values. 
            If you specify multiple values, Amazon Macie uses `AND` logic to join the values.
          eq:
            The value for the property matches (equals) the specified value. 
            If you specify multiple values, Amazon Macie uses `OR` logic to join the values.
          neq:
            The value for the property doesn't match (doesn't equal) the specified value.
            If you specify multiple values, Amazon Macie uses `OR` logic to join the values.
          lt:
            The value for the property is less than the specified value.
          lte:
            The value for the property is less than or equal to the specified value.
          gt:
            The value for the property is greater than the specified value.
          gte:
            The value for the property is greater than or equal to the specified value.

  DOC
}
