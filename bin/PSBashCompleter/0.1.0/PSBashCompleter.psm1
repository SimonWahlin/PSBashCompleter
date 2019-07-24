#Region './_PrefixCode.ps1' 0
# Code in here will be prepended to top of the psm1-file.
#EndRegion './_PrefixCode.ps1' 1
#Region './Public/Register-PSBashCompleter.ps1' 0
function Register-PSBashCompleter {
    param(
        [string]
        $CommandName,
        [string]
        $CompletionLoader
    )
    
    if([string]::IsNullOrWhiteSpace($CompleationLoader)) {
        # Try dynamic loading of completion script
        $LoaderCode = "_completion_loader $CommandName"
    } else {
        $LoaderCode = $CompletionLoader
    }

    $PSBashCompleterCode = @'
        param(
            $CommandName,
            $CommandAst,
            $CursorPosition
        )
        $GenericLoaderCode = @"
            source /usr/share/bash-completion/bash_completion
"@
    
'@ + @"

        `$LoaderCode = "$LoaderCode"

"@ + @'
        $CommandLine = $CommandAst.Extent.Text
        $CommandlineWords = $CommandAst.CommandElements.Value
        $CommandIndex = $CommandlineWords.IndexOf($CommandName)
        if ($CommandIndex -eq -1) {
            # Current word does not exist in $CommandLineWords
            # This means we are at the beginning of a new word
            $CommandIndex = $CommandlineWords.Count
        }
        $BashCode = @"
# set script to exit on any error
#set -o errexit

# Run the generic loader to make sure bash-completion is loaded
$GenericLoaderCode

# Run the specific loader if specified
$LoaderCode

# fill variables with commandline information
# array of words in command line
COMP_WORDS=($CommandlineWords)

# index of the word containing cursor position
COMP_CWORD=$CommandIndex

# command line
COMP_LINE='$Commandline'

# index of cursor position
COMP_POINT=$CursorPosition

# run complete to get the right bash-completion function
completion=`$(complete -p $($CommandlineWords[0]) 2>/dev/null | awk '{print `$(NF-1)}')

# execute completion function 
"`$completion"

# print completions to stdout
printf '%s\n' "`${COMPREPLY[@]}"
"@
        if ($PSVersionTable['Platform'] -eq 'Unix') {
            $Result = $BashCode | bash --
        }
        else {
            $Result = $BashCode | wsl --
        }
        return $Result
'@
    $PSBashCompleter = [scriptblock]::Create($PSBashCompleterCode)
    Register-ArgumentCompleter -CommandName $CommandName -ScriptBlock $PSBashCompleter -Native

}
#EndRegion './Public/Register-PSBashCompleter.ps1' 82
