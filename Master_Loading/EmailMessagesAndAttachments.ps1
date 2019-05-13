﻿Function ArchiveFiles ($file)
{
    $date = Get-Date -uFormat "%Y%m%d"
    
    $ext = $file.Substring($file.LastIndexOf("."))
    $loc = $file.Substring(0,($file.LastIndexOf("\")+1))
    $name = $file.Substring($file.LastIndexOf("\")+1).Replace($ext,"")

    $old = $loc + $name + $ext
    $new = $loc + $name + "_" + $date + $ext
    ## Change Archive if your archive folder has a different naming convention
    $archiveFolder = $loc + "Archive\"
    
    Rename-Item $old $new
    Move-Item $new $archiveFolder
}

Function Gmail_SendMail ($from, $to, $password, $title, $emailfolder, $smtp_server = $null, $attachment = $null)
{
    $u = $from.Substring(0,$from.IndexOf("@"))

    if ($smtp_server -eq $null)
    {
        $smtp_server = "smtp.gmail.com" 
    }

    $smtp = New-Object Net.Mail.SmtpClient($smtp_server, 587) 
    $smtp.EnableSsl = $true 
    $smtp.Credentials = New-Object System.Net.NetworkCredential($u, $password)

    $em = Get-ChildItem $emailfolder -Filter *.txt
    $body = Get-Content $em.FullName
    $email = New-Object Net.Mail.MailMessage
    $email.From = $from
    $email.To.Add($to)
    $email.Subject = $title
    $email.Body = $body

    if ($attachment -ne $null)
    {
        $attachments = Get-ChildItem $attachment
        $archiveattachments = @()

        foreach ($attach in $attachments | Where-Object { $_.PSIsContainer -eq $false })
        {
            $attach = $attach.FullName
            $email.Attachments.Add($attach)
            $archiveattachments += $attach
        }
    }

    $smtp.Send($email)
    $smtp.Dispose()
    $email.Dispose()

    foreach ($a in $archiveattachments)
    {
        ArchiveFiles -file $a
    }

    $f = $em.FullName
    ArchiveFiles -file $f
}

Gmail_SendMail -from "" -to "" -password "" -title "" -emailfolder "C:\files\Email\Messages\" -attachment "C:\files\Email\Attachments\"






