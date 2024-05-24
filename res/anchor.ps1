$pathname = $args[0]
$pathname
$process = Start-Process -FilePath $pathname -Verb RunAs -Wait -PassThru
$process.ExitCode