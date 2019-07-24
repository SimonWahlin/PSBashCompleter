@{
    Path = "PSBashCompleter.psd1"
    OutputDirectory = "..\bin\PSBashCompleter"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
