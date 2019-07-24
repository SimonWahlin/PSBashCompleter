# PSBashCompleter

---

Simple module that uses existing bash-completion in PowerShell. Works on Windows PowerShell as long as completion is set-up in WSL.

Each time completion is made we'll "shell out" to bash (or wsl.exe in Windows) and resolve the completion there. Any command that has working completion in bash/WSL *should* register in PowerShell.

---
Maintained by Simon Wahlin
