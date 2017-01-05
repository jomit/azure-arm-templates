configuration MyFile{
    File MyFile {
        DestinationPath = "C:\MyDSCDemoFile.txt"
        Ensure = 'Present'
        Type = 'File'
        Contents = "DSC is cool!!"
    }
}