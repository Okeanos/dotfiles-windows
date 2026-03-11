[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
Param()

atuin init powershell | Out-String | Invoke-Expression

Invoke-Expression (&starship init powershell)
