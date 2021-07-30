variable "account_status" {
  type        = bool
  description = "Macie account status. Possible values are `ENABLED` and `PAUSED`. Setting it to `ENABLED` will start all Macie activities for the account."
  default     = true
}

variable "admin_account_ids" {
  type        = list(string)
  description = "The list of AWS account IDs for the account to designate as the delegated Amazon Macie administrator accounts for the organization."
  default     = []
}

variable "members" {
  type        = list(any)
  description = <<-DOC
    A list of maps of Amazon Macie Members.
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
  default     = []
}

variable "custom_data_identifiers" {
  type        = list(any)
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
  default     = []
}

variable "classification_jobs" {
  type        = list(any)
  description = <<-DOC
    A list of maps of classification jobs.
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

      schedule_frequency:
        daily_schedule:
          Specifies a daily recurrence pattern for running the job.
        weekly_schedule:
          Specifies a weekly recurrence pattern for running the job.
        monthly_schedule:
          Specifies a monthly recurrence pattern for running the job.

  DOC
  default     = []
}

//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_account#argument-reference
variable "finding_publishing_frequency" {
  type        = string
  description = "Specifies how often to publish updates to policy findings for the account. This includes publishing updates to AWS Security Hub and Amazon EventBridge (formerly called Amazon CloudWatch Events). Valid values are FIFTEEN_MINUTES, ONE_HOUR or SIX_HOURS."
  validation {
    condition     = var.finding_publishing_frequency == "FIFTEEN_MINUTES" || var.finding_publishing_frequency == "ONE_HOUR" || var.finding_publishing_frequency == "SIX_HOURS"
    error_message = "The finding_publishing_frequency value must be one of (\"FIFTEEN_MINUTES\" | \"ONE_HOUR\" | \"SIX_HOURS\")."
  }
  default = "ONE_HOUR"
}
