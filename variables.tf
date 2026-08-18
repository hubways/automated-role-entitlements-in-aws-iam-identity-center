###############################################
# IAM Identity Center Related Variables #
###############################################

variable "new_acnt_perms" {
  description = "List of all the Permission Sets that are applicable for a newly vended AWS Account"
  type        = list(any)
}

variable "sso_instance_arn" {
  description = "The ARN of the IAM Identity Center instance. Used to scope down CreateAccountAssignment permissions."
  type        = string
}