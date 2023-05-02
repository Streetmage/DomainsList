# Example of Swift Command Line Tool implementation in iOS project #

## Usage ##

Project consists of 2 targets:
1. **DomainsList** - iOS project that shows list of available App domains with their configurations
2. **DomainsUpdater** - Swift Command Line Tool that updates info about domains for **DomainsList**, and which can also clean project for debug purposes

When you build and run **DomainsList** in Debug configuraion it will update **domains.json** file and **Info.plist**. For easy debugging you can roll back changes by running **DomainsUpdater** target: it has setup for the clean command.
If you just need to update domains without running application then use **DomainsUpdater.sh**.

## Solving problems with DomainsUpdater.sh running ##

1. Apple sometimes tags this file with quarantine attribute which leads to error like this:
`zsh: operation not permitted: ./DomainsUpdater.sh.`
Use this command to solve it:
`xattr -d com.apple.quarantine DomainsUpdater.sh`
2. Another problem can be:
`xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance`.
If you have Xcode installed (of course you have) then don't install any other utilities. Usually Command Line Tools are installed on Xcode first launch, but sometimes you need to select them manually once more in Xcode Settings -> Locations -> Command Line Tools (even if they've already been selected).
