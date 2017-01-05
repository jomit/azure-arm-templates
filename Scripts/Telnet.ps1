configuration Telnet{
    File Telnet {
        DestinationPath = "C:\TelnetFile.txt"
        Ensure = 'Present'
        Type = 'File'
        Contents = "Telnet code here.."
    }
}