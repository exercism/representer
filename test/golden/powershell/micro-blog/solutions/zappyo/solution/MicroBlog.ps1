Function Invoke-MicroBlog() {
    <#
    .SYNOPSIS
    Implement a function to make micro blog post that only of 5 or less characters.

    .DESCRIPTION
    Given a string, truncate it into a string of maximum 5 characters.

    .PARAMETER Post
    A string object contains Unicode text encoding: alphabets, symbols or even emojis.

    .EXAMPLE
    Invoke-MicroBlog -Post "Lightning"
    Returns: "Light"
    #>
    [CmdletBinding()]
    Param(
        [string]$Post
    )

    if($Post.Length -gt 5){
        Return $Post.Substring(0,4)
    }
    Return $Post
    Throw "Please implement this function"
}