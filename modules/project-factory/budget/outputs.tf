output "name" {
  description = "Resource name of the budget. Values are of the form `billingAccounts/{billingAccountId}/budgets/{budgetId}.`"
  value       = var.create_budget ? google_billing_budget.budget[0].name : ""
}
